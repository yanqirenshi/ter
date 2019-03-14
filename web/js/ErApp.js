class ErApp {
    constructor() {}
    ht2linkHt (data) {
        let out = {};

        if (data._id)
            out._id = data._id;

        if (data._class)
            out._class = data._class;

        return out;
    }
    stateTER2Json (state) {
        let out = {};

        out.cameras = state.cameras.list;
        out.entities = state.entities.list;

        let modifyColumns = (obj) => {
            let new_data = Object.assign({}, obj);

            if (new_data._entity)
                new_data._entity = this.ht2linkHt(obj._entity);

            if (new_data._parent)
                delete new_data._parent;

            return new_data;
        };

        out.identifier_instances = state.identifier_instances.list.map(modifyColumns);
        out.attribute_instances  = state.attribute_instances.list.map(modifyColumns);

        out.relationships = state.relationships.list.map((obj) => {
            let new_data = Object.assign({}, obj);

            if (new_data._from)
                new_data._from = this.ht2linkHt(new_data._from);

            if (new_data._to)
                new_data._to = this.ht2linkHt(new_data._to);

            return new_data;
        });

        out.ports = state.ports.list.map((obj) => {
            let new_data = Object.assign({}, obj);

            delete new_data._element;

            return new_data;
        });

        return JSON.stringify(out, null, 3);
    }
    stateER2Json (state) {
        let out = {};

        out.columns = state.columns.list.slice();
        out.cameras = state.cameras.slice();
        out.column_instances = state.column_instances.list.map((obj) => {
            let new_data = Object.assign({}, obj);

            new_data._table = this.ht2linkHt(new_data._table);
            return new_data;
        });

        out.ports = state.ports.list.map((obj) => {
            let new_data = Object.assign({}, obj);

            new_data._column_instance = this.ht2linkHt(obj._column_instance);
            return new_data;
        });

        out.relashonships = state.relashonships.list.map((obj) => {
            let new_data = Object.assign({}, obj);

            if (obj._port_from)
                new_data._port_from = this.ht2linkHt(obj._port_from);

            if (obj._port_to)
                new_data._port_to = this.ht2linkHt(obj._port_to);

            return new_data;
        });

        out.edges = state.edges.list.map((obj) => {
            let new_data = Object.assign({}, obj);

            if (obj._port_from)
                new_data._port_from = this.ht2linkHt(obj._port_from);

            if (obj._port_to)
                new_data._port_to = this.ht2linkHt(obj._port_to);

            return new_data;
        });

        return JSON.stringify(out, null, 3);
    }
    downloadJson (name, json) {
        var blob = new Blob([ json ], {type : 'application/json'});

        var a = document.createElement("a");
        a.href = URL.createObjectURL(blob);
        a.target = '_blank';
        a.download = name + '.' + moment().format('YYYYMMDDHHmmssZZ') + '.json';
        a.click();

    }
}
