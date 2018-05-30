<page03>

    <svg></svg>

    <script>
     this.d3svg = null;
     this.ter = new Ter();

     STORE.subscribe((action) => {
         if(action.type=='FETCHED-ER')
             this.ter.drawTables(
                 this.d3svg,
                 STORE.state().get('er')
             );
     });

     this.on('mount', () => {
         this.d3svg = this.ter.makeD3svg('page03 > svg');
     });
    </script>
</page03>
