function sum(){
    let args = Array.from(arguments);
    let sum = 0;

    args.forEach((ele) => {
        sum += ele;
    });
    return sum;
}

function sum2(...args) {
    let sum = 0;
    args.forEach((ele) => {
        sum += ele;
    });
    return sum;
}

// the first argument becomes the '.this' context
// the remaining arguments (the bind time args) become the arguments in the method you want to use (i.e. the bound method)
// when invoked, the arguments passed in a second parenthetical (the call time args) also get passed into the bound method


// Function.prototype.myBind = function(context) {
//     let bindArgs = Array.from(arguments).slice(1);

//     return (...callArgs) => {
//         return this.apply(context, bindArgs.concat(callArgs));
//     };
// };

Function.prototype.myBind = function(context) {
    let bindArgs = Array.from(arguments).slice(1);
    that = this;

    return (function x () {
        callArgs = Array.from(arguments);
        return that.apply(context, bindArgs.concat(callArgs));
    });
};

// function(context, arg1, arg2, arg3)
// ...bindArgs = [arg1, arg2, arg3]

Function.prototype.myBind2 = function(context, ...bindArgs) {
    return (...callArgs) => {
        return this.apply(context, bindArgs.concat(callArgs));
    };
};


const sumThree = num1 => num2 => num3 => num1 + num2 + num3;

// What's the difference between?
// function curriedSum (){}  --creates an object curriedSum w/ a function
// const curriedSum = function(){} --creates a variable handle for an anonymous function

const curriedSum = numArgs => {
    const numbers = [];
    
    return function _curriedSum(num) {
        numbers.push(num);
        if (numbers.length < numArgs) {
            return numbers;
        }
        else{
            return numbers.reduce((acc, el) => acc + el); 
        }
    };
};


Function.prototype.curry = function (numArgs) {
    const args = [];

    const _curriedSum = num => {
        args.push(num);
        if (args.length < numArgs) {
            return _curriedSum;
        }
        else {
            return this(...args);
        }
    };
    return _curriedSum;
};

// function sumNums(...args){
//     return args.reduce((acc, el) => acc + el);
// }

//sumNums.curry(4)                               --method style 
// const curry = Function.prototype.curry       --global scope




