#ifndef ENTITY_H
#define ENTITY_H

#include <bits/stdc++.h>
#include <cstdlib>
using namespace std;
#define MAX 10000


class Entity {
private:

    int SIZE, Space;
    bitset<MAX> Knapsack;

    void swap(int &x, int &y){
        x ^= y;
        y ^= x;
        x ^= y;
    }

    void shuffle(int *arr, int size){
        srand(time(0));
        for(int i = size - 1; i > 0; --i) swap(arr[i], arr[rand() % (i+1)]);
    }


    void seed(int Space, int *values, int *weights){
        int arr[SIZE]; iota(arr, arr+SIZE, 0);
        shuffle(arr, SIZE);
        for(int i = 0; i<SIZE && Space > 0; ++i){
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
        if(on.size()) Knapsack.flip(on[rand()%on.size()]);
        if(off.size()) Knapsack.set(off[rand()%off.size()]);
        
    }

public:

    double energy = 0;

    Entity(int SIZE, int *weights, int *values, int Space){
        this->SIZE = SIZE;
        this->Space = Space;
        seed(Space, values, weights);
    }

    Entity(int *values, int *weights, Entity curr){
        this->SIZE = curr.SIZE;
        this->Knapsack = curr.Knapsack;
        this->Space = curr.Space;
        Perturb();
        Energy(this->Space, values, weights);
    }

    void showSolution(int *values, int *weights){
        int value = 0, weight = 0;
        for(int i = 0; i<SIZE; ++i)
            if(Knapsack.test(i)){
                printf("%d ", i);
                value += values[i];
                weight += weights[i];
            } 
        printf("\nKnapsack value: %d\nKnapsack weight: %d\n", value, weight);
        
    }

};



#endif 

