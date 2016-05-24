var myApp = angular.module('myApp',[]);

myApp.controller('myCntrl',function($scope){
    $scope.amount;
});
angular.module('myApp')
    .directive('keyDir',function(){
        return{
            restrict : 'A',
            require: '?^ngModel',
            link : function(scope,elem,attr,model){
             var wu_decimal_separator=",";
                elem.bind('click',function(){
                        elem.val(elem.val().toString().replace(wu_decimal_separator+'00',''));
                        var finalValue;
                        var pastValue = elem.val();
                        CustomKeyboard.open(elem.val(), 9, function(value) {
                           console.log('value ' +value);
                            if(!((value.toString().split(wu_decimal_separator).length - 1 )>1 && pastValue.toString().indexOf(wu_decimal_separator) > 0)){
                                if(value.indexOf(wu_decimal_separator) >= 0 &&  (value.toString().substr(value.toString().indexOf(wu_decimal_separator)+1).length > 2)){
                                    //restrict users to enter anything after two decimal chars.
                                    CustomKeyboard.endEdit(function(){
                                        console.log('failed');
                                        return;
                                    });
                                    return;
                                }else{
                                    if (value == '0000') {
                                        CustomKeyboard.close();
                                    }
                                elem.val(value);
                                pastValue = value;
                                }
                                console.log('Value means '+value);
                            }
                            else{
                                //restrict users to enter multiple decimals. Focus the input after that
                                elem[0].focus();
                                setCaretPosition(elem[0],elem.val().length);
                                
                            }
                        }, function(finished) {
                            console.log(finished);
                            if(finished!=""){
                                finalValue = convertToCurrency(elem.val());
                            }
                            console.log('finalValue '+finalValue);
                            elem.val(finalValue);
                            model.$setViewValue(finalValue);
                            model.$render();
                        })  
                });
            
                function convertToCurrency(amount){
                    var finalAmount="";
                    if(amount.toString().indexOf(wu_decimal_separator) < 0){
                        finalAmount = amount +wu_decimal_separator +"00";
                    }
                    else {
                        var noDigitsAfterDecimal = amount.toString().substr(amount.toString().indexOf(wu_decimal_separator)+1).length;
                        if(noDigitsAfterDecimal ===2){
                            finalAmount = amount;
                        }
                        else{
                            var cnt = noDigitsAfterDecimal;
                            console.log('noDigitsAfterDecimal '+noDigitsAfterDecimal);
                            while(cnt < 2){
                                amount = amount +'0';
                                cnt++;
                            }
                            finalAmount = amount;
                        }
                    }
                    return finalAmount;
                }
                function setCaretPosition(ctrl, pos)
                {
                    if(ctrl.setSelectionRange)
                    {
                        ctrl.focus();
                        ctrl.setSelectionRange(pos,pos);
                    }
                    else if (ctrl.createTextRange) {
                        var range = ctrl.createTextRange();
                        range.collapse(true);
                        range.moveEnd('character', pos);
                        range.moveStart('character', pos);
                        range.select();
                    }
                } // end setCaretPosition
            }
        }
});