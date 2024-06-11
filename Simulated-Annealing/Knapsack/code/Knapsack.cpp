#include "Entity.h"
#include <random>

#define cool_rate 0.9999
#define T_max 100.0
#define T_min 1.0


int SIZE, weights[MAX], costs[MAX], Space;
random_device rd;
mt19937 gen;
uniform_real_distribution<double> dist(0, 1);


bool accept(double Temp, double delta){
    return (delta < 0 || dist(gen) < exp(-delta/Temp))? 1: 0;
}


Entity Simulated_Annealing(){

    double T = T_max;
    Entity curr = Entity(SIZE, weights, costs, Space);
    while(T > T_min){
        Entity New = Entity(costs, weights, &curr);
        if(accept(T, New.energy - curr.energy)) curr = New;
        T *= cool_rate;

    }return curr;

}



int main(){
   
    ios::sync_with_stdio(0); cin.tie(0);
    scanf("%d %d", &SIZE, &Space);
    for(int i = 0; i<SIZE; ++i) scanf("%d %d", &weights[i], &costs[i]);
    Simulated_Annealing().showSolution();
    return 0; 

}

