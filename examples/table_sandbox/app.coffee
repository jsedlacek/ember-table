window.App = Ember.Application.create()
App.Router.map ->
  @route "table"
  @route "tableCell"
  @route "tableRow"
  @route "tableBlock"

App.TableRoute = Ember.Route.extend
  model: ->
    Ember.Object.create
      controller: App.TableSimpleExample.TableController.create()

App.TableCellRoute = Ember.Route.extend
  model: ->
    Ember.Object.create
      row:
        content: Ember.Object.create
          title: "Hello"
          value: "World"
      content: # = collumn
        getCellContent: (row) ->
          return row.get "title"

App.TableRowRoute = Ember.Route.extend
  model: ->
    Ember.Object.create
      content: Ember.Object.create # = row
        content: Ember.Object.create
          title: "Hello"
          value: "World"
      columns:
        Ember.A([
          Ember.Table.ColumnDefinition.create(
            getCellContent: (row) ->
              return row.get "title"
          ),
          Ember.Table.ColumnDefinition.create(
            getCellContent: (row) ->
              return row.get "value"
          )
        ])
      height: 100
      width: 400
      itemIndex: 0
      rowHeight: 100


App.TableBlockRoute = Ember.Route.extend
  model: ->
    Ember.Object.create
      itemViewClass: 'Ember.Table.TableRow'
      content: # = rows
        [1,2,3].map (number) ->
          Ember.Object.create 
          content: Ember.Object.create
            title: "Hello" + number
            value: "World" + number
      columns:
        Ember.A([
          Ember.Table.ColumnDefinition.create(
            getCellContent: (row) ->
              return row.get "title"
          ),
          Ember.Table.ColumnDefinition.create(
            getCellContent: (row) ->
              return row.get "value"
          )
        ])
      height: 100
      width: 400
      itemIndex: 0
      rowHeight: 100
