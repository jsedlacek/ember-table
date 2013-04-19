window.App = Ember.Application.create()
App.Router.map ->
  @route "table"
  @route "tableCell"
  @route "tableRow"
  @route "tableBlock"
  @route "multiHeader"

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
        [1,2,3,4,5].map (number) ->
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
      rowHeight: 25
      numItemsShowing: 4

################################

ColumnDefinition = Ember.Table.ColumnDefinition.extend
    index: 0
    columnWidth: 100
    getCellContent: (row) ->
        row[this.get('index')]

Rows = Ember.ArrayProxy.extend
  prefix: ''
  objectAt: (rowIndex) ->
    row = this.get('content')[rowIndex]
    if row
      row

    numColumns = this.get('controller.numColumns')
    startAt = this.get('startAt')
    prefix = @get 'prefix'

    row = Ember.Object.create
      isLoaded: false
    cellsLoaded = 0;
    for columnIndex in [0..numColumns]
      do (columnIndex) ->
          row[columnIndex] = prefix + columnIndex

    row.set('isLoaded', true)

    this.get('content')[rowIndex] = row
    row

TableController = Ember.Table.TableController.extend
  hasHeader: true
  hasFooter: false
  numFixedColumns: 1
  numFixedRows: 2
  numColumns: 10
  numRows: 50
  columns: Ember.computed ->
    columns = [];
    for i in [0..this.get('numColumns')]
      do ->
        columns.pushObject ColumnDefinition.create
          headerCellName: 'header' + i
          index: i
    columns;
  .property('numColumns'),
  content: Ember.computed ->
      Rows.create
        content: new Array(this.get('numRows') - this.get('numFixedRows'))
        startAt: this.get('numFixedRows')
        controller: this
  .property()
  headerContent: Ember.computed ->
      Rows.create
        prefix: 'Header '
        content: new Array(this.get('numFixedRows'))
        controller: this
  .property()

App.MultiHeaderRoute = Ember.Route.extend
  model: ->
    Ember.Object.create
      controller: TableController.create()