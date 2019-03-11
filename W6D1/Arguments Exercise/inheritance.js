Function.prototype.inherits = function(ParentClass){
    function Surrogate() {}
    Surrogate.prototype = ParentClass.prototype;
    this.prototype = new Surrogate();
    this.prototype.constructor = this;
};


function MovingObject (radius) {
    this.radius = radius;
}

function Ship() { }
Ship.inherits(MovingObject);

function Asteroid(wormName) { 
    this.wormName = wormName;
}


Asteroid.inherits(MovingObject);

Asteroid.prototype.explode = function () {
    this.radius = 0}

