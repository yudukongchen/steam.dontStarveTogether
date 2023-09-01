GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

Recipe("stu_amulet2_1", {Ingredient("dreadstone", 4), Ingredient("transistor", 2), Ingredient("goldnugget", 8)}, RECIPETABS.TOWN, TECH.NONE, 
{no_deconstruction = false}, nil, nil, 1, "stu",
"images/inventoryimages/stu_amulet2_1.xml", 
"stu_amulet2_1.tex")
--, "images/inventoryimages/helena_coin.xml"
Recipe("stu_amulet2_2", {Ingredient("stu_amulet2_1", 1, "images/inventoryimages/stu_amulet2_1.xml", false, "stu_amulet2_1.tex"), Ingredient("dreadstone", 4), Ingredient("redgem", 3), Ingredient("goldnugget", 10)}, RECIPETABS.TOWN, TECH.NONE, 
{no_deconstruction = false}, nil, nil, 1, "stu",
"images/inventoryimages/stu_amulet2_2.xml", 
"stu_amulet2_2.tex")

Recipe("stu_amulet2_3", {Ingredient("stu_amulet2_2", 1, "images/inventoryimages/stu_amulet2_2.xml", false, "stu_amulet2_2.tex"), Ingredient("dreadstone", 4), Ingredient("opalpreciousgem", 4), Ingredient("goldnugget", 12)}, RECIPETABS.TOWN, TECH.NONE, 
{no_deconstruction = false}, nil, nil, 1, "stu",
"images/inventoryimages/stu_amulet2_3.xml", 
"stu_amulet2_3.tex")

Recipe("stu_amulet1_1", {Ingredient("dreadstone", 4), Ingredient("marble", 2), Ingredient("goldnugget", 8)}, RECIPETABS.TOWN, TECH.NONE, 
{no_deconstruction = false}, nil, nil, 1, "stu",
"images/inventoryimages/stu_amulet1_1.xml", 
"stu_amulet1_1.tex")
--, "images/inventoryimages/helena_coin.xml"
Recipe("stu_amulet1_2", {Ingredient("stu_amulet1_1", 1, "images/inventoryimages/stu_amulet1_1.xml", false, "stu_amulet1_1.tex"), Ingredient("dreadstone", 4), Ingredient("redgem", 3), Ingredient("goldnugget", 10)}, RECIPETABS.TOWN, TECH.NONE, 
{no_deconstruction = false}, nil, nil, 1, "stu",
"images/inventoryimages/stu_amulet1_2.xml", 
"stu_amulet1_2.tex")

Recipe("stu_amulet1_3", {Ingredient("stu_amulet1_2", 1, "images/inventoryimages/stu_amulet1_2.xml", false, "stu_amulet1_2.tex"), Ingredient("dreadstone", 4), Ingredient("opalpreciousgem", 4), Ingredient("goldnugget", 12)}, RECIPETABS.TOWN, TECH.NONE, 
{no_deconstruction = false}, nil, nil, 1, "stu",
"images/inventoryimages/stu_amulet1_3.xml", 
"stu_amulet1_3.tex")

Recipe2("stu_chesspiece_hornucopia_builder",    {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,         {nounlock = true, actionstr="SCULPTING", image="chesspiece_hornucopia.tex"})
Recipe2("stu_chesspiece_pipe_builder",          {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,         {nounlock = true, actionstr="SCULPTING", image="chesspiece_pipe.tex"})
Recipe2("stu_chesspiece_anchor_builder",        {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_anchor.tex"})
Recipe2("stu_chesspiece_pawn_builder",          {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_pawn.tex"})
Recipe2("stu_chesspiece_rook_builder",          {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_rook.tex"})
Recipe2("stu_chesspiece_knight_builder",        {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_knight.tex"})
Recipe2("stu_chesspiece_bishop_builder",        {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_bishop.tex"})
Recipe2("stu_chesspiece_muse_builder",          {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_muse.tex"})
Recipe2("stu_chesspiece_formal_builder",        {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_formal.tex"})
Recipe2("stu_chesspiece_deerclops_builder",     {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_deerclops.tex"})
Recipe2("stu_chesspiece_bearger_builder",       {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_bearger.tex"})
Recipe2("stu_chesspiece_moosegoose_builder",    {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_moosegoose.tex"})
Recipe2("stu_chesspiece_dragonfly_builder",     {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_dragonfly.tex"})
Recipe2("stu_chesspiece_minotaur_builder",      {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_minotaur.tex"})
Recipe2("stu_chesspiece_toadstool_builder",     {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_toadstool.tex"})
Recipe2("stu_chesspiece_beequeen_builder",      {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_beequeen.tex"})
Recipe2("stu_chesspiece_klaus_builder",         {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_klaus.tex"})
Recipe2("stu_chesspiece_antlion_builder",       {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_antlion.tex"})
Recipe2("stu_chesspiece_stalker_builder",       {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_stalker.tex"})
Recipe2("stu_chesspiece_malbatross_builder",    {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_malbatross.tex"})
Recipe2("stu_chesspiece_crabking_builder",      {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_crabking.tex"})
Recipe2("stu_chesspiece_butterfly_builder",     {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_butterfly.tex"})
Recipe2("stu_chesspiece_moon_builder",          {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_moon.tex"})
Recipe2("stu_chesspiece_guardianphase3_builder",{Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_guardianphase3.tex"})
Recipe2("stu_chesspiece_eyeofterror_builder",   {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_eyeofterror.tex"})
Recipe2("stu_chesspiece_twinsofterror_builder", {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_twinsofterror.tex"})
Recipe2("stu_chesspiece_clayhound_builder",     {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_clayhound.tex"})
Recipe2("stu_chesspiece_claywarg_builder",      {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_claywarg.tex"})
Recipe2("stu_chesspiece_carrat_builder",        {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_carrat.tex"})
Recipe2("stu_chesspiece_beefalo_builder",       {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_beefalo.tex"})
Recipe2("stu_chesspiece_kitcoon_builder",       {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_kitcoon.tex"})
Recipe2("stu_chesspiece_catcoon_builder",       {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_catcoon.tex"})
Recipe2("stu_chesspiece_manrabbit_builder",     {Ingredient("marble", 2), Ingredient("rocks", 4)},                                     TECH.NONE,                  {nounlock = true, actionstr="SCULPTING", image="chesspiece_manrabbit.tex"})
