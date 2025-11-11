class ResourceMoney {
  final String images;
  final String resource;
  ResourceMoney({required this.images, required this.resource});
}

List<ResourceMoney> listResourceMoney = [
  ResourceMoney(
    images: "assets/icons/pashabank_usd.png",
    resource: "VIETTINBANK",
  ),
  ResourceMoney(images: "assets/icons/cash_usd.png", resource: "Cash VND"),
  ResourceMoney(images: "assets/icons/cash_usd.png", resource: "Cash VND"),
  ResourceMoney(images: "assets/icons/pashabank_usd.png", resource: "MBBANK "),
];
