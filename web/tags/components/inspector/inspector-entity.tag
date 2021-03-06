<inspector-entity>
    <div style="margin-bottom:11px;">
        <h1 class="title is-5">{entityName()}</h1>
    </div>

    <page-tabs core={page_tabs} callback={clickTab}></page-tabs>

    <div class="tabs">
        <inspector-entity-basic      class="hide" entity={entityData()}></inspector-entity-basic>
        <inspector-entity-attributes class="hide" entity={entityData()}></inspector-entity-attributes>
        <inspector-entity-ports      class="hide" entity={entityData()}></inspector-entity-ports>
    </div>

    <script>
     this.page_tabs = new PageTabs([
         {code: 'basic',      label: 'Basic',      tag: 'inspector-entity-basic' },
         {code: 'attributes', label: 'Attributes', tag: 'inspector-entity-attributes' },
         {code: 'ports',      label: 'Ports',      tag: 'inspector-entity-ports' },
     ]);

     this.on('mount', () => {
         this.page_tabs.switchTab(this.tags)
         this.update();
     });

     this.clickTab = (e, action, data) => {
         if (this.page_tabs.switchTab(this.tags, data.code))
             this.update();
     };
    </script>


    <script>
     this.entityName = () => {
         let data = this.entityData();

         if (!data) return '';

         return data._core.name;
     }
     this.entityData = () => {
         let data = this.opts.source;

         if (!data) return null;

         if (data._class=='RESOURCE' ||
             data._class=='RESOURCE-SUBSET' ||
             data._class=='EVENT' ||
             data._class=='EVENT-SUBSET' ||
             data._class=='COMPARATIVE')
             return data;

         return null;
     };
    </script>

    <style>
     inspector-entity {
         display: block;
         width: 100%;
         height: 100%;

         display: flex;
         flex-direction: column;
     }
     inspector-entity .tabs {
         flex-grow: 1;
     }
    </style>

</inspector-entity>
