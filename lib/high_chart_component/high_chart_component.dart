part of highcharts4dart;

@Component (
    selector: 'high-chart',
    useShadowDom: false,
    templateUrl: 'packages/highcharts4dart/high_chart_component/high_chart_component.html',
    publishAs: 'cmp'
)
class HighChartComponent {
  static int currentID = 0;
  
  int _chartID;
  
  Element _element;
  DivElement _chartContainer;
  
  @observable
  HighChart _chartOptions;
  @NgOneWay('chart-options')
  set chartOptions (HighChart co) {
    if (co == null) {
      this._chartOptions = null;
    }
    else {
      _chartOptions = co;
      _chartOptions.changes.listen(_chartOptionsChange);
    }
    _invalidateDisplay();
  }
  get chartOptions => _chartOptions;
  
  bool _domReady = false;
  bool _displayDirty = false;
  
  HighChartComponent (Element elem) {
    this._chartID = currentID++;
    this._element = elem;
    window.animationFrame.then(_checkContainer);
  }
  
  void _checkContainer (_) {
    if (this._element.children.length > 0) {
      _domReady = true;
      _element.children.clear();
      DivElement chartContainer = new DivElement();
      chartContainer.id="chart-container-$_chartID";
      chartContainer.classes.addAll(_element.classes);
                               
      _element.append(chartContainer);
      _invalidateDisplay();
    }
    else {
      window.animationFrame.then(_checkContainer);
    }
  }
  
  void _chartOptionsChange (List<ChangeRecord> changes) {
    _invalidateDisplay();
  }
  
  void invalidateDisplay (){_invalidateDisplay();}
  void _invalidateDisplay () {
    if (!_displayDirty) {
      _displayDirty = true;
      window.animationFrame.then((_) { _updateDisplay(); });
    }
  }
  
void updateDisplay () {_updateDisplay();}
  void _updateDisplay () {
    if (_domReady && _displayDirty && _chartOptions != null) {
      //print ("Update display");
      _createChart ();
    }
    _displayDirty = false;
  }
  
  void _createChart () {
    /* This is the old way. This requires JQuery. It has been replaced by the standalone-framework (https://github.com/highslide-software/highcharts.com/blob/master/js/adapters/standalone-framework.src.js)
    context.callMethod(r'$', ["#chart-container-$_chartID"]).callMethod('highcharts', [new JsObject.jsify(_chartOptions.toMap())]);
    */
    _chartOptions.chart.renderTo = "chart-container-$_chartID";
    new JsObject(context['Highcharts']['Chart'], [new JsObject.jsify(_chartOptions.toMap())]);
  }
  
  
  
}