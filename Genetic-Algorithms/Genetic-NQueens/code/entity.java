import java.util.*;



public class entity implements Comparable<entity>{

    public ArrayList<Integer> board = new ArrayList<>();
    public int size, fitness;
    private Random random = new Random();


    public entity(int size){

        this.size = size;
        for(int i = 0; i<size; i++) board.add(i);
        Collections.shuffle(board);
        Fitness();

    }



    public entity(entity f1, entity f2, int size){

        this.size = size;
        BitSet msk = new BitSet(size);
        int cross = random.nextInt(size);
        for(int i = 0; i<cross; i++){
            board.add(f1.board.get(i));
            msk.set(f1.board.get(i));
        }for(int i = 0; i<size; i++) if(!msk.get(f2.board.get(i))) board.add(f2.board.get(i));

        if(random.nextInt(100) < 5) mutation();
        Fitness();

    }




    private void mutation(){
        Collections.swap(board, random.nextInt(size), random.nextInt(size));
    }



    private void Fitness(){

        fitness = 0;
        for(int col = 0; col<size; col++)
            for(int i = col + 1; i<size; i++) 
                if(Math.abs(col - i) == Math.abs(board.get(col) - board.get(i))) fitness++; 
        
        fitness *= fitness;
        fitness += 2;

    }







    @Override
    public int compareTo(entity x){
        return Integer.compare(fitness, x.fitness);
    }

    @Override
    public boolean equals(Object obj){
        entity x = (entity) obj;
        return x.fitness == fitness;
    }



    public void showBoard(){

        for(int i = 0; i<size; i++){
            for(int j = 0; j<size; j++)
                System.out.print(((board.get(j) == i)? "👑": ((i+j)%2 == 1)? "⬛": "⬜"));
            System.out.println();

        }System.out.println("fitness: " + (fitness - 2));

    }



}