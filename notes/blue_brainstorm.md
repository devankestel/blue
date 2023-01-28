* Same dimensions as non-blue canvas
* Different sprites 
* Protagonist sprite should enter blue mode on same grid location as it was on with non-blue
    * Exception: protagonist is at a location that is forbidden in blue mode - e.g. wall 
        * What should the location change to in this case? 
* How should we keep track of state between modes? 
    * Perhaps by exporting canvas when blue mode starts and importing it back when blue mode ends? 
    * on State struct - counter: integer
    * on State struct - blue: boolean
    