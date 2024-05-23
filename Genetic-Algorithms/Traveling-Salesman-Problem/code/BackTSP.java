import java.util.*;


public class BackTSP{

    private int V;
    private Graph graph;
    private final int INF = 1<<20;
    private int START;
    private int END_STATE;
    private Object lock;

    public BackTSP(int size, Graph graph, Object lock){

        this.lock = lock;
        this.graph = graph;
        V = size;
        END_STATE = (1<<V)-1;

    }

    private boolean TEST(int msk, int i){
        return (msk&(1<<i)) != 0;
    }


    private int SET(int msk, int i){
        return msk|(1<<i);
    }


    private pair<Integer, List<Integer>> min(pair<Integer, List<Integer>> x, pair<Integer, List<Integer>> y){

        if(x.first < y.first) return x;
        return y;

    }


    private pair<Integer, List<Integer>> findMin(int curr, int msk, ArrayList<Integer> path, int cost){

        path.add(curr);

        if(msk == END_STATE) return new pair<>(graph.getCost(curr, START) + cost, path);

        pair<Integer, List<Integer>> rslt = new pair<>(INF, new ArrayList<>());

        for(int i = 0; i<V; i++)

            if(graph.getCost(curr, i) != INF && !TEST(msk, i)) 

                rslt = min(rslt, findMin(i, SET(msk, i), new ArrayList<>(path), cost + graph.getCost(curr, i)));

        return rslt;

    }


    private pair<Integer, List<Integer>> solveTSP(){

        pair<Integer, List<Integer>> rslt = new pair<>(INF, new ArrayList<>());
        for(int i = 0; i<V; i++){
            
            START = i;
            rslt = min(rslt, findMin(i, (1<<i), new ArrayList<>(), 0));
        
        }return rslt;

    }


    public void showBackTSP(){

        pair<Integer, List<Integer>> rslt = solveTSP();
        synchronized (lock) {
            System.out.println("Backtracking cost: " + rslt.first);
            System.out.print("Backtracking tour: ");
            System.out.print(rslt.second.get(rslt.second.size()-1) + 1 + " ");
            for(Integer i: rslt.second) System.out.print(i+1 + " ");
            System.out.println();
        }

    }




}