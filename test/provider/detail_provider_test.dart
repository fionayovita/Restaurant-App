import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/api/api_service.dart';
import 'package:restaurant_app/model/detail_model.dart';

import 'detail_provider_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Testing api parsing', () {
    test(
      "test to verify api parse for detail",
      () async {
        //arrange
        final client = MockClient();
        final apiService = ApiService(client: client);

        //act
        when(
          client.get(
            Uri.parse(
                'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
              '{"error":false,"message":"success","restaurant":{"id":"rqdv5juczeskfw1e867","name":"Melting Pot","description":"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.","city":"Medan","address":"Jln. Pandeglang no 19","pictureId":"14","categories":[{"name":"Italia"},{"name":"Modern"}],"menus":{"foods":[{"name":"Paket rosemary"},{"name":"Toastie salmon"},{"name":"Bebek crepes"},{"name":"Salad lengkeng"}],"drinks":[{"name":"Es krim"},{"name":"Sirup"},{"name":"Jus apel"},{"name":"Jus jeruk"},{"name":"Coklat panas"},{"name":"Air"},{"name":"Es kopi"},{"name":"Jus alpukat"},{"name":"Jus mangga"},{"name":"Teh manis"},{"name":"Kopi espresso"},{"name":"Minuman soda"},{"name":"Jus tomat"}]},"rating":4.2,"customerReviews":[{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"13 November 2019"},{"name":"tes","review":"tes","date":"28 Agustus 2021"},{"name":"senja","review":"mudahan enak","date":"28 Agustus 2021"},{"name":"Hdh","review":"Dbnd","date":"28 Agustus 2021"},{"name":"coba review","review":"manteub bangeut dah ah!","date":"28 Agustus 2021"},{"name":"test review","review":"keren nih buat nongki2","date":"28 Agustus 2021"},{"name":"Paijo","review":"AOkowkowkwo","date":"28 Agustus 2021"}]}}',
              200),
        );

        //assert
        expect(
          await apiService.getDetail("rqdv5juczeskfw1e867"),
          isA<DetailResult>(),
        );
      },
    );

    test('throws exception if error', () async {
      final client = MockClient();
      final apiService = ApiService(client: client);

      when(client.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer((_) async => http.Response('Failed', 404));

      final call = apiService.getDetail("rqdv5juczeskfw1e867");

      expect(() => call, throwsException);
    });
  });
}
