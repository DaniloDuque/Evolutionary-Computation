import java.util.*;

class Graph{

    private int[][] adjacencyMatrix;
    private int size;
    private final int INF = (1<<20);

    public Graph(int size) {
        this.size = size;
        this.adjacencyMatrix = new int[size][size];
        for(int i = 0; i<size; i++)
            for(int j = 0; j<size; j++)
                adjacencyMatrix[i][j] = INF;

    }

    public void addEdge(int sourceId, int destinationId, int cost) {
        adjacencyMatrix[sourceId][destinationId] = cost;
        adjacencyMatrix[destinationId][sourceId] = cost;
    }

    public int getCost(int sourceId, int destinationId) {
        return adjacencyMatrix[sourceId][destinationId];
    }
        
        
}
