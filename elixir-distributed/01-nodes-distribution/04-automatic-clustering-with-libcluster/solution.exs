# Node A
DaLibclusterTest.start_building(A)
DaLibclusterTest.building_at_this_node?(A)
# returns true

# Node B
DaLibclusterTest.building_at_this_node?(A)
# returns false/ error
DaLibclusterTest.get_rooms_for_building_at_node(A, :"a@wannes-Latitude-7490")
# returns result
