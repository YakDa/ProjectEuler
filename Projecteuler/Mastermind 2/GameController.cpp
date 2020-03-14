/*
 * GameController.cpp 
 * GameController class used to define opponent behavior
 * Writter:  Cai Mingda
 * Date:     8 Nov, 2015
 */

#include <iostream>
#include <array>
#include <string>
#include <random>
#include "GameController.h"

using namespace std;


GameController::GameController()
{
    
}

/*
 **************************************************************************
 * generateRnd()
 *    Generate 4 random integer between 1 and 6 in array result.
 **************************************************************************
 */
void GameController::generateRnd()
{
    random_device rd;
    mt19937 mt(rd());
    uniform_int_distribution<int> dist(1, COLOR_NUM);

    for(short i = 0; i < SLOT_NUM; i++)
    {
        result[i] = dist(mt);
    }
}


/*
 **************************************************************************
 * checkResult(array<int, 4> slot)
 *     check if the sequence player provided matching the result,
 *     and give a summary report for player's references.
 **************************************************************************
 */
int GameController::checkResult(array<int, SLOT_NUM> slot)
{
    short correct_position_number = 0;
    short correct_number_only = 0;

    // Temp buffer of result and slot for modifcation
    array<int, SLOT_NUM> result_temp;
    array<int, SLOT_NUM> slot_temp;
    
    // Check how many slots having correction positions and numbers
    // Mark those correct one with 0 in both result_temp and slot_temp
    for(short i = 0; i < SLOT_NUM; i++)
    {
        result_temp[i] = result[i];
        slot_temp[i] = slot[i];

        if(slot[i] == result_temp[i])
        {
            result_temp[i] = 0;
            slot_temp[i] = 0;
            correct_position_number++;
        }
    }
    
    // Check how many slots having correction numbers but wrong positions
    // Skipped if slot_temp or result_temp marked with 0
    // Mark those having correct numbers but wrong positions with 0 in both result_temp and slot_temp
    for(short i = 0; i < SLOT_NUM; i++)
    {
        if(slot_temp[i] == 0) continue;

        for(short j = 0; j < SLOT_NUM; j++)
        {
            if ((result_temp[j] != 0) && (slot_temp[i] == result_temp[j]))
            {
                slot_temp[i] = 0;
                result_temp[j] = 0;
                correct_number_only++;
                break;
            }
        }
    }


    for(int i = 0; i < SLOT_NUM; i++)
        summary[counter] = summary[counter] + ' ' + to_string(slot[i]);

    summary[counter] = summary[counter] + "  " + "Black pegs = " + to_string(correct_position_number) \
                       + "  " + "White pegs = " + to_string(correct_number_only) + '\n';
    counter++;

    summaryReport();

    if(correct_position_number == SLOT_NUM)
        return true;
    else
        return false;
}


/*
 **************************************************************************
 * summaryReport()
 *     Private function, display a summary report for player's references
 **************************************************************************
 */
void GameController::summaryReport()
{
    cout << "\n\n";
    cout << "Summary Report:\n";
    for(int i =0; i < counter; i++)
    {
        cout << summary[i];
    }
    cout << "\n\n";
    cout << "\n\n";
}


