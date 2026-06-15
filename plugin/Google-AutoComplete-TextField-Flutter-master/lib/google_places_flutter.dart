library google_places_flutter;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import 'DioErrorHandler.dart';

class GooglePlaceAutoCompleteTextField extends StatefulWidget {
  InputDecoration inputDecoration;
  ItemClick? itemClick;
  GetPlaceDetailswWithLatLng? getPlaceDetailWithLatLng;
  bool isLatLngRequired = true;

  TextStyle textStyle;
  String googleAPIKey;
  int debounceTime = 600;
  List<String>? countries = [];
  TextEditingController textEditingController = TextEditingController();
  ListItemBuilder? itemBuilder;
  Widget? seperatedBuilder;
  void clearData;
  BoxDecoration? boxDecoration;
  bool isCrossBtnShown;
  bool showError;
  final bool enabled;
  double? containerHorizontalPadding;
  double? containerVerticalPadding;
  FocusNode? focusNode;
  PlaceType? placeType;
  String? language;
  TextInputAction? textInputAction;
  final VoidCallback? formSubmitCallback;
  TextInputType? keyboardType;

  final String? Function(String?, BuildContext)? validator;

  final double? latitude;
  final double? longitude;

  /// This is expressed in **meters**
  final int? radius;

  GooglePlaceAutoCompleteTextField(
      {required this.textEditingController,
      required this.googleAPIKey,
      this.debounceTime = 600,
      this.inputDecoration = const InputDecoration(),
      this.itemClick,
      this.isLatLngRequired = true,
      this.textStyle = const TextStyle(),
      this.countries,
      this.getPlaceDetailWithLatLng,
      this.itemBuilder,
      this.boxDecoration,
      this.isCrossBtnShown = true,
      this.seperatedBuilder,
      this.showError = true,
      this.containerHorizontalPadding,
      this.containerVerticalPadding,
      this.focusNode,
      this.placeType,
      this.language = 'en',
      this.validator,
      this.latitude,
      this.longitude,
      this.radius,
      this.formSubmitCallback,
      this.textInputAction,
      this.keyboardType,
      this.clearData, required this.enabled});

  @override
  _GooglePlaceAutoCompleteTextFieldState createState() =>
      _GooglePlaceAutoCompleteTextFieldState();
}

class _GooglePlaceAutoCompleteTextFieldState
    extends State<GooglePlaceAutoCompleteTextField> {
  final subject = new PublishSubject<String>();
  OverlayEntry? _overlayEntry;
  List alPredictions = [];

  TextEditingController controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  bool isSearched = false;

  bool isCrossBtn = true;
  late var _dio;

  CancelToken? _cancelToken = CancelToken();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: widget.containerHorizontalPadding ?? 0,
            vertical: widget.containerVerticalPadding ?? 0),
        alignment: Alignment.centerLeft,
        decoration: widget.boxDecoration ??
            BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey, width: 0.6),
                borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                decoration: widget.inputDecoration,
                enabled : widget.enabled,
                style: widget.textStyle,
                controller: widget.textEditingController,
                focusNode: widget.focusNode ?? FocusNode(),
                keyboardType: widget.keyboardType ?? TextInputType.streetAddress,
                textInputAction: widget.textInputAction ?? TextInputAction.done,
                onFieldSubmitted: (value) {
                  if(widget.formSubmitCallback!=null){
                    widget.formSubmitCallback!();
                  }

                },
                validator: (inputString) {
                  return widget.validator?.call(inputString, context);
                },
                onChanged: (string) {
                  subject.add(string);
                  if (widget.isCrossBtnShown) {
                    isCrossBtn = string.isNotEmpty ? true : false;
                    setState(() {});
                  }
                },
              ),
            ),
            (!widget.isCrossBtnShown)
                ? SizedBox()
                : isCrossBtn && _showCrossIconWidget()
                    ? IconButton(onPressed: clearData, icon: Icon(Icons.close))
                    : SizedBox()
          ],
        ),
      ),
    );
  }

  void clearData() {
    widget.textEditingController.clear();

    // 🔑 Cancel current request if running
    if (_cancelToken?.isCancelled == false) {
      _cancelToken?.cancel();
    }
    _cancelToken = CancelToken(); // new token for next request

    setState(() {
      alPredictions.clear();
      isCrossBtn = false;
    });

    if (this._overlayEntry != null) {
      try {
        this._overlayEntry?.remove();
      } catch (e) {
        print("Overlay remove error: $e");
      }
    }
  }

  getLocation(String text) async {
    String apiURL = "https://places.googleapis.com/v1/places:autocomplete";

    if (_cancelToken?.isCancelled == false) {
      _cancelToken?.cancel();
      _cancelToken = CancelToken();
    }

    // If input is empty, clear overlay and return
    if (text.isEmpty) {
      alPredictions.clear();
      _overlayEntry?.remove();
      return;
    }

    try {
      Map<String, dynamic> body = {
        "input": text,
        "languageCode": widget.language ?? "en",
        "locationBias": {
          "rectangle": {
            "low": {"latitude": 8.0, "longitude": 68.0},
            "high": {"latitude": 37.0, "longitude": 97.0}
          }
        }
      };

      Response response = await _dio.post(
        apiURL,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "X-Goog-Api-Key": widget.googleAPIKey,
            "X-Goog-FieldMask":
            "suggestions.placePrediction.placeId,"
                "suggestions.placePrediction.text.text,"
                "suggestions.placePrediction.structuredFormat.mainText.text,"
                "suggestions.placePrediction.structuredFormat.secondaryText.text"
          },
        ),
        cancelToken: _cancelToken,
      );

      Map map = response.data;
      if (map.containsKey("error")) throw response.data;

      List suggestions = map["suggestions"] ?? [];

      // Only update predictions if API returned results
      if (suggestions.isNotEmpty) {
        alPredictions.clear();
        alPredictions.addAll(await Future.wait(suggestions.map((s) async {
          var p = Prediction();
          p.placeId = s["placePrediction"]["placeId"];
          p.mainText =
          s["placePrediction"]["structuredFormat"]["mainText"]["text"];
          p.secondaryText =
          s["placePrediction"]["structuredFormat"]["secondaryText"]["text"];

          // Fetch full formatted address
          String? address = await getPlaceAddress(p.placeId!);
          p.description = address ?? s["placePrediction"]["text"]["text"];
          return p;
        })));

        // Insert overlay only if predictions exist
        _overlayEntry?.remove();
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
      } else {
        // No valid suggestions → clear overlay and predictions
        alPredictions.clear();
        _overlayEntry?.remove();
      }

    } catch (e) {
      // var errorHandler = ErrorHandler.internal().handleError(e);
      // _showSnackBar("${errorHandler.message}");
    }
  }


  /// 🔑 Fetch full formatted address using placeId
  Future<String?> getPlaceAddress(String placeId) async {
    try {
      final response = await _dio.get(
        "https://places.googleapis.com/v1/places/$placeId",
        queryParameters: {
          "fields": "formattedAddress"
        },
        options: Options(headers: {
          "X-Goog-Api-Key": widget.googleAPIKey,
          "X-Goog-FieldMask": "formattedAddress"
        }),
      );

      if (response.statusCode == 200) {
        return response.data["formattedAddress"];
      }
    } catch (e) {
      print("❌ Place details error: $e");
    }
    return null;
  }




  @override
  void initState() {
    super.initState();
    _dio = Dio();
    subject.stream
        .distinct()
        .debounceTime(Duration(milliseconds: widget.debounceTime))
        .listen(textChanged);
  }

  textChanged(String text) async {
    if (text.isNotEmpty) {
      getLocation(text);
    } else {
      alPredictions.clear();
      this._overlayEntry!.remove();
    }
  }

  OverlayEntry? _createOverlayEntry() {
    if (context.findRenderObject() != null) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);
      return OverlayEntry(
          builder: (context) => Positioned(
                left: offset.dx,
                top: size.height + offset.dy,
                width: size.width,
                child: CompositedTransformFollower(
                  showWhenUnlinked: false,
                  link: this._layerLink,
                  offset: Offset(0.0, size.height + 5.0),
                  child: Material(
                      child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: alPredictions.length,
                    separatorBuilder: (context, pos) =>
                        widget.seperatedBuilder ?? SizedBox(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          var selectedData = alPredictions[index];
                          if (index < alPredictions.length) {
                            widget.itemClick!(selectedData);

                            if (widget.isLatLngRequired) {
                             await getPlaceDetailsFromPlaceId(selectedData);
                            }
                            removeOverlay();
                          }
                        },
                        child: widget.itemBuilder != null
                            ? widget.itemBuilder!(
                                context, index, alPredictions[index])
                            : Container(
                                padding: EdgeInsets.all(10),
                                child: Text(alPredictions[index].description!)),
                      );
                    },
                  )),
                ),
              ));
    }
  }

  removeOverlay() {
    alPredictions.clear();
    this._overlayEntry = this._createOverlayEntry();

    Overlay.of(context).insert(this._overlayEntry!);
    this._overlayEntry!.markNeedsBuild();
  }

  Future<void> getPlaceDetailsFromPlaceId(Prediction prediction) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=${prediction.placeId}&key=${widget.googleAPIKey}&fields=formatted_address,geometry";

    try {
      Response response = await _dio.get(url);

      if (response.statusCode == 200 && response.data["status"] == "OK") {
        var result = response.data["result"];

        // ✅ Full formatted address
        prediction.description = result["formatted_address"];

        // ✅ Lat / Lng
        prediction.lat = result["geometry"]["location"]["lat"].toString();
        prediction.lng = result["geometry"]["location"]["lng"].toString();

        // 🔥 Callback with complete Prediction
        widget.getPlaceDetailWithLatLng!(prediction);
      } else {
        _showSnackBar("Place details not found");
      }
    } catch (e) {
      var errorHandler = ErrorHandler.internal().handleError(e);
      _showSnackBar("${errorHandler.message}");
    }
  }



  _showCrossIconWidget() {
    return (widget.textEditingController.text.isNotEmpty);
  }

  _showSnackBar(String errorData) {
    if (widget.showError) {
      final snackBar = SnackBar(
        content: Text("$errorData"),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

PlacesAutocompleteResponse parseResponse(Map responseBody) {
  return PlacesAutocompleteResponse.fromJson(
      responseBody as Map<String, dynamic>);
}

PlaceDetails parsePlaceDetailMap(Map responseBody) {
  return PlaceDetails.fromJson(responseBody as Map<String, dynamic>);
}

typedef ItemClick = void Function(Prediction postalCodeResponse);
typedef GetPlaceDetailswWithLatLng = void Function(
    Prediction postalCodeResponse);

typedef ListItemBuilder = Widget Function(
    BuildContext context, int index, Prediction prediction);
