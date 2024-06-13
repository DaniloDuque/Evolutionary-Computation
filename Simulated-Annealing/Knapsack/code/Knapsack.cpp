#include "Entity.h"
#include <cstdlib>

#define cool_rate 0.99
#define T_max 100.0
#define T_min 0.0001


int SIZE, weights[MAX], values[MAX], Space;

bool accept(double T, double delta){
    return delta < 0 || (double)rand()/RAND_MAX < exp(-delta/T);
}

Entity Simulated_Annealing(){

    Entity curr = Entity(SIZE, weights, values, Space);
    for(double T = T_max;T > T_min; T *= cool_rate){
        Entity New = Entity(values, weights, curr);
        if(New.energy != 0 && accept(T, curr.energy - New.energy)) curr = New;

    }return curr;

}

int main(){

    scanf("%d %d", &SIZE, &Space);
    for(int i = 0; i<SIZE; ++i) scanf("%d %d", &weights[i], &values[i]);
    Simulated_Annealing().showSolution(values, weights);
    return 0; 

}

