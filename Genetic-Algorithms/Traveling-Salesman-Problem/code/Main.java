import java.util.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.StringTokenizer;


public class Main{


    public static void main(String [] args) throws IOException{

        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String inputLine = reader.readLine();
        StringTokenizer tokenizer = new StringTokenizer(inputLine);

        int V = Integer.parseInt(tokenizer.nextToken());
        int E = Integer.parseInt(tokenizer.nextToken());

        Graph graph = new Graph(V);

        for(int i = 0; i<E; i++){

            inputLine = reader.readLine();
            tokenizer = new StringTokenizer(inputLine);
            int v1 = Integer.parseInt(tokenizer.nextToken());
            int v2 = Integer.parseInt(tokenizer.nextToken());
            int cost = Integer.parseInt(tokenizer.nextToken());
            graph.addEdge(--v1, --v2, cost);

        }
        
        
        Object lock = new Object();
        GeneticTSP x = new GeneticTSP(V, graph, lock);
        DynamicTSP y = new DynamicTSP(V, graph, lock);
        BackTSP z = new BackTSP(V, graph, lock);
        Thread threadX = new Thread(() -> x.showGeneticTSP());
        Thread threadY = new Thread(() -> y.showDynamicTSP());
        Thread threadZ = new Thread(() -> z.showBackTSP());
        threadX.start();
        threadY.start();
        threadZ.start();
       
    }

}