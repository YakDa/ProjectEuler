/*
 * GamePlayer.h 
 * GamePlayer class used to define player behavior
 * Writter:  Cai Mingda
 * Date:     8 Nov, 2015
 */

#include <array>

using namespace std;

#ifndef GAMEPLAYER_H
#define GAMEPLAYER_H

#define SLOT_NUM 4      // 4 numbers in one sequence
#define COLOR_NUM 6     // 1 slot has 6 options to choose

/*
 * Class GamePlayer
 * 
 */
class GamePlayer 
{
public:
    array<int, SLOT_NUM> slot;
    void guessNumber();
private:
    void changeNumber(int index);
};

#endif
