import java.util.*;




public class DynamicTSP{

    private Graph graph;
    private int V;
    private int END_STATE;
    private int START;
    private final int INF = 1<<20;
    private ArrayList<Integer> hamiltonianCycle = new ArrayList<>();
    private Object lock;
    

    public DynamicTSP(int V, Graph graph, Object lock){

        this.lock = lock;
        this.graph = graph;
        this.V = V;
        END_STATE = (1<<V)-1;

    }

    private boolean TEST(int msk, int i){
        return (msk&(1<<i)) != 0;
    }

    private int SET(int msk, int i){
        return msk|(1<<i);
    }


    private int findMinCost(int i, int state, HashMap<pair<Integer, Integer>, Integer> dp, HashMap<pair<Integer, Integer>, Integer> parent){

        if(state == END_STATE) return graph.getCost(i, START);  //if visited all nodes, return the distance between i and START

        pair<Integer, Integer> key = new pair<>(i, state);

        if(dp.containsKey(key)) return dp.get(key);            //if key is cached return dp[key]

        int minCost = INF;
        int index = -1;

        for(int nxt = 0; nxt < V; nxt++){

            if(TEST(state, nxt) || graph.getCost(i, nxt) == INF) continue;   //if the node was visited or no edge between i and nxt, continue

            int newCost = graph.getCost(i, nxt) + findMinCost(nxt, SET(state, nxt), dp, parent);

            if(newCost < minCost){

                minCost = newCost;
                index = nxt;

            }

        }parent.put(key, index);
        dp.put(key, minCost);
        return minCost;

    }
    


    private int solve() {

        int minTourCost = Integer.MAX_VALUE, start = 0;
        HashMap<pair<Integer, Integer>, Integer> parent = new HashMap<>();
        HashMap<pair<Integer, Integer>, Integer> aux = new HashMap<>();

        for(int i = 0; i<V; i++){

            aux = new HashMap<>();
            START = i;
            int minDist = findMinCost(START, (1<<i), new HashMap<>(), aux);
            if(minDist < minTourCost){

                minTourCost = minDist;
                start = i;
                parent = aux;

            }


        }int state = 1<<start;
        int index = start;
        while(true){
            
            hamiltonianCycle.add(index);
            Integer nextIndex = parent.get(new pair<>(index, state));
            if (nextIndex == null) break;
            int nextState = SET(state, nextIndex);
            state = nextState;
            index = nextIndex;

        }hamiltonianCycle.add(start);
        return minTourCost;

    }








    public void showDynamicTSP(){

        int min = solve();
        synchronized (lock){

            System.out.println("Dynamic cost: " + min);
            System.out.print("Dynamic tour: ");
            for(Integer i: hamiltonianCycle) System.out.print(i+1 + " ");
            System.out.println();
            
        }

    }





}