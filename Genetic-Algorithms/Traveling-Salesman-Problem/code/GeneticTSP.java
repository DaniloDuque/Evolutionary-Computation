import java.util.*;



public class GeneticTSP{


    private entityTSP gen[];
    private PriorityQueue<entityTSP> heap = new PriorityQueue<>();
    private int genSize, V, noChanges = 0;
    private double genSum = 0;
    private Random random = new Random();
    private entityTSP best;
    private Graph G;
    private Object lock;



    public GeneticTSP(int V, Graph G, Object lock){

        this.lock = lock;
        this.V = V;
        this.G = G; 
        genSize = V;
        gen = new entityTSP[genSize];
        for(int i = 0; i<genSize; i++) gen[i] = new entityTSP(V, G);
        best = new entityTSP(gen[0], gen[1], V, G);

    }



    

    private double fitness(entityTSP i){
        return genSum/i.fitness;
    }

    private void updateBest(){

        genSum = 0.0;
        entityTSP curr = best;
        for(entityTSP i: gen){
            genSum += i.fitness;
            if(i.fitness < curr.fitness) curr = i;
        }noChanges = (best.equals(curr))? noChanges + 1: 0;
        best = curr;

    }

    


    private entityTSP findTour(){

        while(noChanges < (V*V*V)){
                        
            updateBest();
            for(int i = 0; i<genSize; i++){

                double target1 = random.nextDouble() * genSum, target2 = random.nextDouble() * genSum;
                double cumulativeFit = 0.0;

                int j = 0;
                while(cumulativeFit < target1 && j < genSize) cumulativeFit += fitness(gen[j++]);
                entityTSP f1 = gen[Math.max(j-1, 0)];

                cumulativeFit = j = 0;
                while(cumulativeFit < target2 && j < genSize) cumulativeFit += fitness(gen[j++]);
                entityTSP f2 = gen[Math.max(j-1, 0)];

                heap.add(gen[i]);
                heap.add(new entityTSP(f1, f2, V, G));

            }for(int i = 0; i<genSize; i++) gen[i] = heap.poll();
            heap.clear();

        }return best;

    }


    public void showGeneticTSP(){

        entityTSP bst = findTour();
        synchronized(lock){
            
            System.out.println("Genetic cost: " + bst.fitness);
            System.out.print("Genetic tour: ");
            for(int i: bst.tour) System.out.print(i+1 + " ");
            System.out.println(bst.tour.get(0) + 1);

        }

    }




}