local sounds={
[1] = {ID=1,effectDesc=13,build="",harvest="",arms="",wish="",box="",loop=1,sound="m_city"},
[2] = {ID=2,effectDesc=12,build="",harvest="",arms="",wish="",box="",loop=1,sound="m_field"},
[3] = {ID=3,effectDesc=1,build="",harvest="",arms="",wish="",box="",loop=0,sound="ui_confirm"},
[4] = {ID=4,effectDesc=2,build="",harvest="",arms="",wish="",box="",loop=0,sound="ui_cancle"},
[5] = {ID=5,effectDesc=3,build="",harvest="",arms="",wish="",box="",loop=0,sound="ui_slide"},
[6] = {ID=6,effectDesc=0,build="",harvest="",arms="",wish="",box="",loop=0,sound="city_click"},
[7] = {ID=7,effectDesc=4,build="",harvest="",arms="",wish="",box="",loop=0,sound="city_building"},
[8] = {ID=8,effectDesc=5,build=1,harvest="",arms="",wish="",box="",loop=0,sound="city_castle"},
[9] = {ID=9,effectDesc=5,build=2,harvest="",arms="",wish="",box="",loop=0,sound="city_depot"},
[10] = {ID=10,effectDesc=5,build=3,harvest="",arms="",wish="",box="",loop=0,sound="city_walls"},
[11] = {ID=11,effectDesc=5,build=4,harvest="",arms="",wish="",box="",loop=0,sound="city_watchtower"},
[12] = {ID=12,effectDesc=5,build=5,harvest="",arms="",wish="",box="",loop=0,sound="city_wood"},
[13] = {ID=13,effectDesc=5,build=6,harvest="",arms="",wish="",box="",loop=0,sound="city_farm"},
[14] = {ID=14,effectDesc=5,build=7,harvest="",arms="",wish="",box="",loop=0,sound="city_iron"},
[15] = {ID=15,effectDesc=5,build=8,harvest="",arms="",wish="",box="",loop=0,sound="city_mithril"},
[16] = {ID=16,effectDesc=5,build=9,harvest="",arms="",wish="",box="",loop=0,sound="city_college"},
[17] = {ID=17,effectDesc=5,build=10,harvest="",arms="",wish="",box="",loop=0,sound="city_embassy"},
[18] = {ID=18,effectDesc=5,build=11,harvest="",arms="",wish="",box="",loop=0,sound="city_wishing"},
[19] = {ID=19,effectDesc=5,build=12,harvest="",arms="",wish="",box="",loop=0,sound="city_market"},
[20] = {ID=20,effectDesc=5,build=13,harvest="",arms="",wish="",box="",loop=0,sound="city_barrack"},
[21] = {ID=21,effectDesc=5,build=14,harvest="",arms="",wish="",box="",loop=0,sound="city_stable"},
[22] = {ID=22,effectDesc=5,build=15,harvest="",arms="",wish="",box="",loop=0,sound="city_range"},
[23] = {ID=23,effectDesc=5,build=16,harvest="",arms="",wish="",box="",loop=0,sound="city_chariot"},
[24] = {ID=24,effectDesc=5,build=17,harvest="",arms="",wish="",box="",loop=0,sound="city_military"},
[25] = {ID=25,effectDesc=5,build=18,harvest="",arms="",wish="",box="",loop=0,sound="city_hospital"},
[26] = {ID=26,effectDesc=5,build=19,harvest="",arms="",wish="",box="",loop=0,sound="city_hall"},
[27] = {ID=27,effectDesc=5,build=20,harvest="",arms="",wish="",box="",loop=0,sound="city_fortress"},
[28] = {ID=28,effectDesc=5,build=21,harvest="",arms="",wish="",box="",loop=0,sound="city_train"},
[29] = {ID=29,effectDesc=5,build=22,harvest="",arms="",wish="",box="",loop=0,sound="city_turret"},
[30] = {ID=30,effectDesc=5,build=23,harvest="",arms="",wish="",box="",loop=0,sound="city_blacksmith"},
[31] = {ID=31,effectDesc=5,build=24,harvest="",arms="",wish="",box="",loop=0,sound="ui_confirm"},
[32] = {ID=32,effectDesc=5,build=25,harvest="",arms="",wish="",box="",loop=0,sound="ui_confirm"},
[33] = {ID=33,effectDesc=5,build=26,harvest="",arms="",wish="",box="",loop=0,sound="ui_confirm"},
[34] = {ID=34,effectDesc=5,build=27,harvest="",arms="",wish="",box="",loop=0,sound="ui_confirm"},
[35] = {ID=35,effectDesc=5,build=28,harvest="",arms="",wish="",box="",loop=0,sound="ui_confirm"},
[36] = {ID=36,effectDesc=5,build=29,harvest="",arms="",wish="",box="",loop=0,sound="ui_confirm"},
[37] = {ID=37,effectDesc=5,build=30,harvest="",arms="",wish="",box="",loop=0,sound="ui_confirm"},
[38] = {ID=38,effectDesc=5,build=31,harvest="",arms="",wish="",box="",loop=0,sound="ui_confirm"},
[39] = {ID=39,effectDesc=5,build=32,harvest="",arms="",wish="",box="",loop=0,sound="ui_confirm"},
[40] = {ID=40,effectDesc=5,build=33,harvest="",arms="",wish="",box="",loop=0,sound="ui_confirm"},
[41] = {ID=41,effectDesc=6,build=5,harvest=0,arms="",wish="",box="",loop=0,sound="harvest_wood"},
[42] = {ID=42,effectDesc=6,build=6,harvest=1,arms="",wish="",box="",loop=0,sound="harvest_farm"},
[43] = {ID=43,effectDesc=6,build=7,harvest=2,arms="",wish="",box="",loop=0,sound="harvest_iron"},
[44] = {ID=44,effectDesc=6,build=8,harvest=3,arms="",wish="",box="",loop=0,sound="harvest_mithril"},
[45] = {ID=45,effectDesc=6,build=13,harvest=4,arms="",wish="",box="",loop=0,sound="harvest_soldier"},
[46] = {ID=46,effectDesc=6,build=14,harvest=5,arms="",wish="",box="",loop=0,sound="harvest_soldier"},
[47] = {ID=47,effectDesc=6,build=15,harvest=6,arms="",wish="",box="",loop=0,sound="harvest_soldier"},
[48] = {ID=48,effectDesc=6,build=16,harvest=7,arms="",wish="",box="",loop=0,sound="harvest_soldier"},
[49] = {ID=49,effectDesc=6,build=20,harvest=8,arms="",wish="",box="",loop=0,sound="harvest_soldier"},
[50] = {ID=50,effectDesc=6,build=23,harvest=9,arms="",wish="",box="",loop=0,sound="harvest_light"},
[51] = {ID=51,effectDesc=7,build="",harvest="",arms=0,wish="",box="",loop=0,sound="world_march"},
[52] = {ID=52,effectDesc=7,build="",harvest="",arms=1,wish="",box="",loop=0,sound="city_drill"},
[53] = {ID=53,effectDesc=7,build="",harvest="",arms=2,wish="",box="",loop=0,sound="world_attack"},
[54] = {ID=54,effectDesc=7,build="",harvest="",arms=3,wish="",box="",loop=0,sound="world_march"},
[55] = {ID=55,effectDesc=8,build=11,harvest="",arms="",wish=0,box="",loop=0,sound="harvest_wood"},
[56] = {ID=56,effectDesc=8,build=11,harvest="",arms="",wish=1,box="",loop=0,sound="harvest_farm"},
[57] = {ID=57,effectDesc=8,build=11,harvest="",arms="",wish=2,box="",loop=0,sound="harvest_iron"},
[58] = {ID=58,effectDesc=8,build=11,harvest="",arms="",wish=3,box="",loop=0,sound="harvest_mithril"},
[59] = {ID=59,effectDesc=8,build=11,harvest="",arms="",wish=4,box="",loop=0,sound="harvest_light"},
[60] = {ID=60,effectDesc=9,build="",harvest="",arms="",wish="",box=0,loop=0,sound="ui_roulette"},
[61] = {ID=61,effectDesc=9,build="",harvest="",arms="",wish="",box=1,loop=0,sound="ui_collect"},
[62] = {ID=62,effectDesc=9,build="",harvest="",arms="",wish="",box=2,loop=0,sound="ui_guide"},
[63] = {ID=63,effectDesc=9,build="",harvest="",arms="",wish="",box=3,loop=0,sound="ui_shuffle"},
[64] = {ID=64,effectDesc=9,build="",harvest="",arms="",wish="",box=4,loop=0,sound="ui_collect"},
[65] = {ID=65,effectDesc=9,build="",harvest="",arms="",wish="",box=5,loop=0,sound="ui_reward"},
[66] = {ID=66,effectDesc=9,build="",harvest="",arms="",wish="",box=6,loop=0,sound="ui_loteryrwd"}
}
return sounds
