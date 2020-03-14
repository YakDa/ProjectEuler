/*
 * GamePlayer.cpp 
 * GamePlayer class used to define player behavior
 * Writter:  Cai Mingda
 * Date:     8 Nov, 2015
 */


#include <iostream>
#include <array>
#include <string>
#include "GamePlayer.h"

using namespace std;


/*
 **************************************************************
 * guessNumber()
 *     Ask player to input 4 integer numbers between 1 and 6
 **************************************************************
 */
void GamePlayer::guessNumber()
{
    char s;
    int i;

    cout << "Please input 4 integer numbers between 1 and 6:\n";
    cout << "(Numbers should be separated by space, then press enter)\n";
    
    for(int i = 0; i < SLOT_NUM; i++)
        cin >> slot[i];
        
    cout << "Check?(y/n)\n";
    cin >> s;
        
    // In case Player want to change the number before check
    if(s == 'n')
    {
        cout << "Please specify which number you want to change?\n";
        cin >> i;
        changeNumber(i);
    }
  
    // Data validation checking
    for(i = 0; i < SLOT_NUM; i++)
    {
        if (slot[i] <= 0 || slot[i] > COLOR_NUM)
        {
            cout << "Number " << i+1 << " slot is invalid, please input another number between 1 and 6:\n";
            changeNumber(i+1);
        }
    }
}

/*
 *******************************************************************
 * changeNumber(int index)
 *     private function, change the number at index in slot array
 *******************************************************************
 */
void GamePlayer::changeNumber(int index)
{
    // Get the input again from player
    cin >> slot[index-1];

    // Data validation checking
    if (slot[index-1] <= 0 || slot[index-1] > COLOR_NUM)
    {
        cout << "Number " << index << " slot is invalid, please input another number between 1 and 6:\n";
        changeNumber(index);
    }
}

