import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class RecipeImageGenerator {
  Future<List<String>> generateImage_favoriteScreen(
      int i, int id, String recipeTitle) async {
    try {
      var params = {
        'title': recipeTitle,
      };
      var uri = Uri.https(
          'http-byof-recipe-gen.azurewebsites.net', '/api/byof_llm_get_image');
      // send request to openAI on Azure
      var response_fromAzure = await http.post(uri, body: jsonEncode(params));
      String currentUrls_fordisplay = response_fromAzure.body;
      // correct: log("image network by openAI: ${response_fromAzure.body}");

      // download the image from the URL and save in local storage
      var response = await http.get(Uri.parse(currentUrls_fordisplay));
      if (response.statusCode == 200) {
        Directory documentdirectory = await getApplicationDocumentsDirectory();
        String imageName = path.basename(currentUrls_fordisplay);
        File file = new File(path.join(documentdirectory.path, imageName));
        await file.writeAsBytes(response.bodyBytes);
        // return imageName for saving in db
        return [imageName, currentUrls_fordisplay];
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print("Error: $e");
      // In case of any error, explicitly throw an exception
      throw Exception("Failed to generate or save the image: $e");
    }
  }

  Future<String> generateImage_GenerationScreen(String recipeTitle) async {
    try {
      var params = {
        'title': recipeTitle,
      };
      var uri = Uri.https(
          'http-byof-recipe-gen.azurewebsites.net', '/api/byof_llm_get_image');
      // send request to openAI on Azure
      var response_fromAzure = await http.post(uri, body: jsonEncode(params));
      String currentUrls_fordisplay = response_fromAzure.body;
      // download the image from the URL and save in local storage
      var response = await http.get(Uri.parse(currentUrls_fordisplay));
      if (response.statusCode == 200) {
        // return imageName for saving in db
        return currentUrls_fordisplay;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print("Error: $e");
      // In case of any error, explicitly throw an exception
      throw Exception("Failed to generate or save the image: $e");
    }
  }
}
