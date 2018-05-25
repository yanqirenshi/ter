<page01>
    <svg></svg>

    <script>
     this.d3svg = null;
     this.graph = new Graph();

     this.drawNods = ()=>{
         let state = STORE.state().get('graph');
         let nodes = state.nodes;
         let svg = this.d3svg._svg;

         return svg.selectAll('circle')
                   .data(nodes.list)
                   .enter()
                   .append('circle')
                   .attr('class', (d)=>{
                       return 'node ' + d._class.toLowerCase();
                   })
                   .attr('cx', (d)=>{ return d.x })
                   .attr('cy', (d)=>{ return d.y })
                   .attr('r', '33')
                   .attr('fill', '#f88');
     };

     this.drawEdges = ()=>{
         let state = STORE.state().get('graph');
         let nodes = state.nodes.ht;
         let edges = state.edges.list;
         let svg = this.d3svg._svg;

         return svg.selectAll('line')
                   .data(edges)
                   .enter()
                   .append('line')
                   .attr('class', 'edges')
                   .attr('x1', (d)=>{ return nodes[d['from-id']].x })
                   .attr('y1', (d)=>{ return nodes[d['from-id']].y })
                   .attr('x2', (d)=>{ return nodes[d['to-id']].x })
                   .attr('y2', (d)=>{ return nodes[d['to-id']].y })
                   .attr('stroke', "#888888");
     };

     STORE.subscribe((action) => {
         if(action.type=='FETCHED-GRAPH') {
             let state = STORE.state().get('graph');
             let nodes = state.nodes;
             let w = window.innerWidth * 3;
             let h = window.innerHeight * 3;

             for (var i in nodes.list) {
                 nodes.list[i].x = this.graph.random(w, 'x');
                 nodes.list[i].y = this.graph.random(h, 'y');
             }

             this.drawEdges();
             this.drawNods();
         }
     });

     this.on('mount', () => {
         this.d3svg = this.graph.makeD3svg('page01 > svg');
     });

     ACTIONS.fetchGraph();
    </script>
</page01>
