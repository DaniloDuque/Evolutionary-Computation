#ifndef ENTITY_H
#define ENTITY_H

#include <bits/stdc++.h>
using namespace std;
#define MAX 10000

extern random_device rd;
extern mt19937 gen;

class Entity {
private:

    int SIZE, Space;
    bitset<MAX> Knapsack;
    uniform_int_distribution<int> dist;    

    void seed(int Space, int *values, int *weights){
        int arr[SIZE]; iota(arr, arr+SIZE, 0);
        shuffle(arr, arr+SIZE, gen);
        for(int i = 0; i<SIZE && Space > 0; ++i)
            if(weights[arr[i]] <= Space){
                Space -= weights[arr[i]];
                energy += values[arr[i]];
                Knapsack.set(i);
            }

        energy *= (Space >= 0);

    }

    void Energy(int Space, int *values, int *weights){
        for(int i = 0; i<SIZE && Space > 0; ++i)
            if(Knapsack.test(i)){
                Space -= weights[i];
                energy += values[i];
            }

        energy *= (Space >= 0);

    }

    void Perturb(){
        vector<int> on, off;
        for(int i = 0; i<SIZE; ++i) (Knapsack.test(i)? on.push_back(i) : off.push_back(i));
        if(on.size()) Knapsack.flip(on[dist(gen)%on.size()]);
        if(off.size()) Knapsack.set(off[dist(gen)%off.size()]);
        
    }

public:

    double energy = 0;

    Entity(int SIZE, int *weights, int *values, int Space){
        this->SIZE = SIZE;
        this->Space = Space;
        seed(Space, values, weights);
    }

    Entity(int *values, int *weights, Entity &curr) : dist(0, MAX){
        this->SIZE = curr.SIZE;
        this->Knapsack = curr.Knapsack;
        Perturb();
        Energy(curr.Space, values, weights);
    }

    void showSolution(){

        for(int i = 0; i<SIZE; ++i) if(Knapsack.test(i)) printf("%d ", i);
        printf("Energy: %lf\n", energy);

    }
};



#endif 

