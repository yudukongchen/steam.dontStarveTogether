require"class"
require"util"
CustomPrefab=Class(
Prefab,function(self,a,b,c,d,e,f,g,h,i,j)
Prefab._ctor(self,a,b,c,d,e)self.name=a;
self.atlas=f and resolvefilepath(f)or resolvefilepath("images/inventoryimages.xml")
self.imagefn=type(g)=="function"and g or nil;self.image=self.imagefn==nil and g or"torch.tex"
self.swap_build=i;
local k={
common_head1={
swap={"swap_hat"},
hide={"HAIR_NOHAT","HAIR","HEAD"},
show={"HAT","HAIR_HAT","HEAD_HAT"}},
common_head2={swap={"swap_hat"},
show={"HAT"}},
common_body={
swap={"swap_body"}},
common_hand={
swap={"swap_object"},
hide={"ARM_normal"},
show={"ARM_carry"}}}self.swap_data=k[j]~=nil and k[j]or j end)