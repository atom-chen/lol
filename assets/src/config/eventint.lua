local eventint={
[1] = {ID=1,eventtype=1,goal=101100,goal1="采集1点粮食",prop=1},
[2] = {ID=2,eventtype=1,goal=101101,goal1="采集1点木头",prop=1},
[3] = {ID=3,eventtype=1,goal=101102,goal1="采集1点金币",prop=24000},
[4] = {ID=4,eventtype=1,goal=101103,goal1="采集1点铁矿",prop=6},
[5] = {ID=5,eventtype=1,goal=101104,goal1="采集1点秘银",prop=24},
[6] = {ID=6,eventtype=2,goal=101105,goal1="提升1点建筑战力",prop=100},
[7] = {ID=7,eventtype=2,goal=101106,goal1="提升1点研究战力",prop=100},
[8] = {ID=8,eventtype=3,goal=101107,goal1="1级怪物",prop=100},
[9] = {ID=9,eventtype=3,goal=101108,goal1="2级怪物",prop=200},
[10] = {ID=10,eventtype=3,goal=101109,goal1="3级怪物",prop=300},
[11] = {ID=11,eventtype=3,goal=101110,goal1="4级怪物",prop=400},
[12] = {ID=12,eventtype=3,goal=101111,goal1="5级怪物",prop=500},
[13] = {ID=13,eventtype=3,goal=101112,goal1="6级怪物",prop=600},
[14] = {ID=14,eventtype=3,goal=101113,goal1="7级怪物",prop=700},
[15] = {ID=15,eventtype=3,goal=101114,goal1="8级怪物",prop=800},
[16] = {ID=16,eventtype=3,goal=101115,goal1="9级怪物",prop=900},
[17] = {ID=17,eventtype=3,goal=101116,goal1="10级怪物",prop=1000},
[18] = {ID=18,eventtype=3,goal=101117,goal1="11级怪物",prop=1100},
[19] = {ID=19,eventtype=3,goal=101118,goal1="12级怪物",prop=1200},
[20] = {ID=20,eventtype=3,goal=101119,goal1="13级怪物",prop=1300},
[21] = {ID=21,eventtype=3,goal=101120,goal1="14级怪物",prop=1400},
[22] = {ID=22,eventtype=3,goal=101121,goal1="15级怪物",prop=1500},
[23] = {ID=23,eventtype=3,goal=101122,goal1="16级怪物",prop=1600},
[24] = {ID=24,eventtype=3,goal=101123,goal1="17级怪物",prop=1700},
[25] = {ID=25,eventtype=3,goal=101124,goal1="18级怪物",prop=1800},
[26] = {ID=26,eventtype=3,goal=101125,goal1="19级怪物",prop=1900},
[27] = {ID=27,eventtype=3,goal=101126,goal1="20级怪物",prop=2000},
[28] = {ID=28,eventtype=3,goal=101127,goal1="21级怪物",prop=2100},
[29] = {ID=29,eventtype=3,goal=101128,goal1="22级怪物",prop=2200},
[30] = {ID=30,eventtype=3,goal=101129,goal1="23级怪物",prop=2300},
[31] = {ID=31,eventtype=3,goal=101130,goal1="24级怪物",prop=2400},
[32] = {ID=32,eventtype=3,goal=101131,goal1="25级怪物",prop=2500},
[33] = {ID=33,eventtype=3,goal=101132,goal1="26级怪物",prop=2600},
[34] = {ID=34,eventtype=3,goal=101133,goal1="27级怪物",prop=2700},
[35] = {ID=35,eventtype=3,goal=101134,goal1="28级怪物",prop=2800},
[36] = {ID=36,eventtype=3,goal=101135,goal1="29级怪物",prop=2900},
[37] = {ID=37,eventtype=3,goal=101136,goal1="30级怪物",prop=3000},
[38] = {ID=38,eventtype=4,goal=101137,goal1="提升1点战力",prop=1},
[39] = {ID=39,eventtype=4,goal=101138,goal1="降低1点战力",prop=-1},
[40] = {ID=40,eventtype=5,goal=101139,goal1="训练1个1级士兵",prop=10},
[41] = {ID=41,eventtype=5,goal=101140,goal1="训练1个2级士兵",prop=20},
[42] = {ID=42,eventtype=5,goal=101141,goal1="训练1个3级士兵",prop=40},
[43] = {ID=43,eventtype=5,goal=101142,goal1="训练1个4级士兵",prop=75},
[44] = {ID=44,eventtype=5,goal=101143,goal1="训练1个5级士兵",prop=130},
[45] = {ID=45,eventtype=5,goal=101144,goal1="训练1个6级士兵",prop=215},
[46] = {ID=46,eventtype=5,goal=101145,goal1="训练1个7级士兵",prop=330},
[47] = {ID=47,eventtype=5,goal=101146,goal1="训练1个8级士兵",prop=490},
[48] = {ID=48,eventtype=5,goal=101147,goal1="训练1个9级士兵",prop=700},
[49] = {ID=49,eventtype=5,goal=101148,goal1="训练1个10级士兵",prop=970},
[50] = {ID=50,eventtype=6,goal=101149,goal1="击杀1级兵",prop=2},
[51] = {ID=51,eventtype=6,goal=101150,goal1="击杀2级兵",prop=4},
[52] = {ID=52,eventtype=6,goal=101151,goal1="击杀3级兵",prop=8},
[53] = {ID=53,eventtype=6,goal=101152,goal1="击杀4级兵",prop=15},
[54] = {ID=54,eventtype=6,goal=101153,goal1="击杀5级兵",prop=26},
[55] = {ID=55,eventtype=6,goal=101154,goal1="击杀6级兵",prop=43},
[56] = {ID=56,eventtype=6,goal=101155,goal1="击杀7级兵",prop=66},
[57] = {ID=57,eventtype=6,goal=101156,goal1="击杀8级兵",prop=98},
[58] = {ID=58,eventtype=6,goal=101157,goal1="击杀9级兵",prop=140},
[59] = {ID=59,eventtype=6,goal=101158,goal1="击杀10级兵",prop=194}
}
return eventint
