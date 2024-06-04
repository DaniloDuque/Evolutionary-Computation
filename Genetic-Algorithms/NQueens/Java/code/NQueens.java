import java.util.*;


public class NQueens{

    private entity gen[];
    private PriorityQueue<entity> heap = new PriorityQueue<>();
    private int genSize, noChanges = -1, size;
    private double genSum;
    private Random random = new Random();
    private entity best;


    public NQueens(int size){

        this.size = size;
        genSize = (size*3);
        gen = new entity[genSize];
        for(int i = 0; i<genSize; i++){
            gen[i] = new entity(size);
            heap.add(gen[i]);
        
        }best = gen[0];

    }



    

    private double fitness(entity x){
        return genSum/(x.fitness);
    }

    private void updateBest(){

        genSum = 0.0;
        for(int i = 0; i<genSize; i++) genSum += fitness(gen[i]);
        entity aux = heap.peek();
        noChanges = (aux.equals(best))? noChanges+1: 0;
        best = aux;

    }



    public entity GeneticNQueens(int show){

        while(noChanges < size*size && best.fitness > 2){

            if(show == 1) best.showBoard();
            for(int i = 1; i<genSize; i++){

                double target1 = random.nextDouble() * genSum, target2 = random.nextDouble() * genSum;
                double cumulativeFit = 0.0;
                entity f1 = null, f2 = null;

                int j = 0;
                while(cumulativeFit < target1 && j < genSize) cumulativeFit += fitness(gen[j++]);
                f1 = gen[Math.max(j-1, 0)];

                cumulativeFit = 0.0; j = 0;
                while(cumulativeFit < target2 && j < genSize) cumulativeFit += fitness(gen[j++]);
                f2 = gen[Math.max(j-1, 0)];

                heap.add(gen[i]);
                heap.add(new entity(f1, f2, size));

            }for(int i = 0; i<genSize; i++) gen[i] = heap.poll();
            updateBest();
            heap.clear();
        
        }return best;

    }




    public static void main(String [] args){

        Scanner scan = new Scanner(System.in);
        NQueens n = new NQueens(scan.nextInt());
        n.GeneticNQueens(scan.nextInt()).showBoard();

    }


}