#include <iostream>
#include <vector>
#include <fstream>
#include <string>

#define pb push_back
#define forn(i, n) for (int i = 0; i < (int)(n); ++i)
#define fornn(i, a, b) for (int i = (int)(a); i < (int)(b); ++i)

using namespace std;

typedef vector<int> vi;
typedef vector<string> vs;
typedef vector<vi> vvi;

int calcpower(int serial, int x, int y){
	int rackID = x+10;
	int powstart = ((rackID*y)+serial)*rackID;
	string hund = to_string(powstart);
	int res = 0;
	if(hund.size() > 2){
		res = stoi(hund.substr(hund.size()-3, 1));
	}
	return res-5;
}

int main(){

	ifstream file("input11.txt");
	vs data;
	string tmp;
	while (getline(file, tmp)){
		data.pb(tmp);
	}

	int serial = stoi(data[0]);
	int gridsize = 300;
	vvi grid (gridsize, vi(gridsize, 0));

	forn(row, grid.size()){
		forn(col, grid[row].size()){
			grid[row][col] = calcpower(serial, col+1, row+1);
		}
	}
	int maxpow = 0;
	int coord[2] = {0, 0};
	int targetkern = 1;
	int val = 0;

	fornn(kernsize, 1, 51){ // just because im too lazy to calculate till 300
		forn(row, grid.size() - kernsize-1){
			forn(col, grid[row].size() - kernsize-1){
				val = 0;
				forn(i, kernsize-1){
					forn(j, kernsize-1){
						val += grid[row+i][col+j];
					}
				}
				if(val > maxpow){
					maxpow = val;
					coord[0] = col+1;
					coord[1] = row+1;
					targetkern = kernsize-1;
				}
			}
		}
	}

	printf("%d,%d,%d\n", coord[0], coord[1], targetkern);

	return 0;
}
