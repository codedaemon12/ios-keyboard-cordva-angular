/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
//var app = {
//    // Application Constructor
//    initialize: function() {
//        this.bindEvents();
//    },
//    // Bind Event Listeners
//    //
//    // Bind any events that are required on startup. Common events are:
//    // 'load', 'deviceready', 'offline', and 'online'.
//    bindEvents: function() {
//        document.addEventListener('deviceready', this.onDeviceReady, false);
//    },
//    // deviceready Event Handler
//    //
//    // The scope of 'this' is the event. In order to call the 'receivedEvent'
//    // function, we must explicitly call 'app.receivedEvent(...);'
//    onDeviceReady: function() {
//        app.receivedEvent('deviceready');
//    },
//    // Update DOM on a Received Event
//    receivedEvent: function(id) {
//        var parentElement = document.getElementById(id);
//        var listeningElement = parentElement.querySelector('.listening');
//        var receivedElement = parentElement.querySelector('.received');
//
//        listeningElement.setAttribute('style', 'display:none;');
//        receivedElement.setAttribute('style', 'display:block;');
//
//        console.log('Received Event: ' + id);
//    }
//};
//
//app.initialize();

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
                elem.bind('click',function(){
                   //document.getElementById('test1').value
                    console.log('elem '+elem.val());
                    var finalValue;
                    var pastValue = elem.val();
                    CustomKeyboard.open(elem.val(), 9, function(value) {
                       console.log('value ' +value);
                        if(!((value.toString().split('.').length - 1 )>1 && pastValue.toString().indexOf('.') > 0)){
                            if(value.indexOf('.') > 0 &&  (value.toString().substr(value.toString().indexOf('.')+1).length > 2)){
                                return false;
                            }else{
                                if (value == '0000') {
                                    CustomKeyboard.close();
                                }
                            elem.val(value);
                            pastValue = value;
                            }
                            
                        }
                        else{
                            elem[0].focus();
                            setCaretPosition(elem[0],elem.val().length);
                        }
                    }, function(finished) {
                        console.log(finished);
                        finalValue = elem.val();
                                       // console.log(finalValue);
                        model.$setViewValue(finalValue);
                        model.$render();
                    // alert('Keyboard closed');
                    })
                });
            
                
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