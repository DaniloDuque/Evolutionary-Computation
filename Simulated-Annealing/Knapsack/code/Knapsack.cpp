#include "Entity.h"

#define cool_rate 0.9999
#define T_max 1000.0
#define T_min 1.0


int SIZE, weights[MAX], values[MAX], Space;


double randP(){
    return (double)rand() / RAND_MAX;
}

bool accept(double T, double delta){
    return delta < 0 || randP() < exp(-delta/T);
}

Entity Simulated_Annealing(){

    Entity curr = Entity(SIZE, weights, values, Space);
    for(double T = T_max;T > T_min; T *= cool_rate){
        Entity New = Entity(values, weights, curr);
        if(accept(T, curr.energy - New.energy)) curr = New;

    }return curr;

}

int main(){

    scanf("%d %d", &SIZE, &Space);
    for(int i = 0; i<SIZE; ++i) scanf("%d %d", &weights[i], &values[i]);
    Simulated_Annealing().showSolution(values, weights);
    return 0; 

}

