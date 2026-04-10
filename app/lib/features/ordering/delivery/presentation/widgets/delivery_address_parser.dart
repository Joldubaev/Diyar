/// Утилита для парсинга адреса из строки
class DeliveryAddressParser {
  /// Парсит адрес из строки, разделяя на основную часть и номер дома
  /// 
  /// Пример: "ул. Ленина, д. 5, кв. 10" -> address: "ул. Ленина", houseNumber: "д. 5, кв. 10"
  static ({String? address, String? houseNumber}) parseAddress(String? address) {
    if (address == null || address.isEmpty) {
      return (address: null, houseNumber: null);
    }

    final parts = address.split(', ');
    if (parts.isEmpty) {
      return (address: address, houseNumber: null);
    }

    final parsedAddress = parts[0];
    final parsedHouseNumber = parts.length > 1 ? parts.sublist(1).join(', ') : null;

    return (address: parsedAddress, houseNumber: parsedHouseNumber);
  }
}

