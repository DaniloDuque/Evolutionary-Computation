import java.util.*;




public class entityTSP implements Comparable<entityTSP>{

    public ArrayList<Integer> tour = new ArrayList<>();
    private int size;
    public long fitness = 0;
    private Random random = new Random();


    public entityTSP(int size, Graph G){

        this.size = size;
        for(int i = 0; i<size; i++) tour.add(i);
        Collections.shuffle(tour);
        fitness(G);

    }

    

    public entityTSP(entityTSP f1, entityTSP f2, int size, Graph G){

        this.size = size;
        int crossStart = random.nextInt(size);
        int crossEnd = (crossStart + random.nextInt(size - 1)+1)%size;
        int msk = 0;

        for(int i = crossStart; i != crossEnd; i = (i + 1)%size){
            tour.add(f1.tour.get(i));
            msk = SET(msk, f1.tour.get(i));
        }

        for(int i = 0; i < size; i++){
            int city = f2.tour.get((crossEnd + i)%size);
            if (!TEST(msk, city)) tour.add(city);

        }if(random.nextInt(100) < 5) mutation(G);
        fitness(G);

    }


    private void mutation(Graph G){
        
        Collections.swap(tour, random.nextInt(size), random.nextInt(size));
        boolean improved = true;
        while(improved){
        
            improved = false;
            for (int i = 1; i < size - 1; i++) 
                for (int j = i + 1; j < size; j++) {
                    int currentCost = G.getCost(tour.get(i - 1), tour.get(i)) +
                                    G.getCost(tour.get(i), tour.get(i + 1)) +
                                    G.getCost(tour.get(j - 1), tour.get(j)) +
                                    G.getCost(tour.get(j), tour.get((j + 1) % size));

                    int newCost = G.getCost(tour.get(i - 1), tour.get(j)) +
                                G.getCost(tour.get(j), tour.get(i + 1)) +
                                G.getCost(tour.get(j - 1), tour.get(i)) +
                                G.getCost(tour.get(i), tour.get((j + 1) % size));

                    if (newCost < currentCost) {
                        Collections.swap(tour, i, j);
                        improved = true;
                    }
                }
            
        }

    }
    

    
    private boolean TEST(int msk, int i){
        return (msk&(1<<i)) != 0;
    }
    private int SET(int msk, int i){
        return msk|(1<<i);
    }

    private void fitness(Graph G){
        for(int i = 0; i<size; i++) fitness += G.getCost(tour.get(i), tour.get((i+1)%size));
    }





    
    @Override
    public int compareTo(entityTSP x){
        return Long.compare(fitness, x.fitness);
    }

    @Override
    public boolean equals(Object obj){
        entityTSP curr = (entityTSP) obj;
        return curr.fitness == fitness;
    }




}