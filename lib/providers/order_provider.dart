import '../models/order.dart';
import 'base_provider.dart';

class OrderProvider extends BaseProvider<Order> {
  OrderProvider() : super("Narudzba");

  @override
  fromJson(data) {
    // TODO: implement fromJson
    return Order();
  }
}