angular.module('app').controller 'supportCtrl', [
  '$http'
  ($http) ->
    vm = this

    vm.conditionalDelete = ->
      $http.delete('/api/conditionalDelete?table=' + vm.table + '&key=' + vm.key).then (response) ->
        console.log response
        return
      return

    return
]