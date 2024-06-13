#include "Entity.h"

#define cool_rate 0.999
#define T_max 100.0
#define T_min 1.0


int SIZE, weights[MAX], values[MAX], Space;
random_device rd;
mt19937 gen;
uniform_real_distribution<double> randF(0, 1);


bool accept(double T, double delta){
    return delta < 0 || randF(gen) < exp(-delta/T);
}


Entity Simulated_Annealing(){

    double T = T_max;
    Entity curr = Entity(SIZE, weights, values, Space);
    while(T > T_min){
        Entity New = Entity(values, weights, curr);
        if(accept(T, curr.energy - New.energy)) curr = New;
        T *= cool_rate;

    }return curr;

}


int main(){

    scanf("%d %d", &SIZE, &Space);
    for(int i = 0; i<SIZE; ++i) scanf("%d %d", &weights[i], &values[i]);
    Simulated_Annealing().showSolution();
    return 0; 

}

