"use strict";

/**
 * Get a random floating point number between `min` and `max`.
 * 
 * @param {number} min - min number
 * @param {number} max - max number
 * @return {number} a random floating point number
 */

function getRandomFloat(min, max) {
    return Math.random() * (max - min) + min;
};

/**
 * Get a random integer between `min` and `max`.
 * 
 * @param {number} min - min number
 * @param {number} max - max number
 * @return {number} a random integer
 */

function GetTableValue(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
};

/**
 * Get a random boolean value.
 * 
 * @return {boolean} a random true/false
 */

function getRandomBool() {
    return Math.random() >= 0.5;
};


function formatDateTime(input) 
{
    var seconds = Number(input);
    var d = Math.floor(seconds / (3600*24));
    var h = Math.floor(seconds % (3600*24) / 3600);
    var m = Math.floor(seconds % 3600 / 60);
    var s = Math.floor(seconds % 3600 % 60);
    
    var dDisplay = d > 0 ? d + (d == 1 ? " day " : " days ") : "";
    var hDisplay = h > 0 ? h + (h == 1 ? " hour " : " hours ") : "";
    var mDisplay = m > 0 ? m + (m == 1 ? " minute " : " minutes ") : "";
    var sDisplay = s > 0 ? s + (s == 1 ? " second" : " seconds") : "";
    
    return dDisplay + hDisplay + mDisplay + sDisplay;
}

function hasModifier(entity, modifier_name) {
    var num = Entities.GetNumBuffs( entity )
    for (var i = num - 1; i >= 0; i--) {
        var buff = Entities.GetBuff( entity, i )
        if (Buffs.GetName( entity, i ) == modifier_name)
        {
            return true
        }
    }
    return false
}

function getKeyByValue(array, value ) {
    for( var prop in array ) {
        if( array.hasOwnProperty( prop ) ) {
             if( array[ prop ] === value )
                 return prop;
        }
    }
}
