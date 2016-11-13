(function () {
'use strict';

angular.module('LunchCheck', [])
.controller('LunchCheckController', LunchCheckController);

LunchCheckController.$inject = ['$scope', '$filter'];
function LunchCheckController($scope, $filter) {
  $scope.str = "";

  $scope.checkIfTooMuch = function () {
  	var arrLenght = $scope.str.split(",").length
  	if ($scope.str == "") {
  		$scope.message = "Please enter data first"
  	} else if (arrLenght < 4) {
  		$scope.message = "Enjoy!";
  	}
  	else {
  		$scope.message = "Too much!";
  	}
  };
}

})();
