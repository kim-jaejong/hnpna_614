import 'package:photo_manager/photo_manager.dart';

class ImageFolders {
  Future<List<AssetPathEntity>> folderList() async {
    List<AssetPathEntity> folderList = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          orders: [
            const OrderOption(
              type: OrderOptionType.createDate,
              asc: true,
            )
          ],
        ));
    return folderList;
  }

  Future<List<AssetEntity>> imageList(AssetPathEntity folder) async {
    int total = await folder.assetCountAsync; //  앨범에 있는 이미지의 총 갯수
    List<AssetEntity> imageList =
        await folder.getAssetListPaged(page: 0, size: total);
    return imageList;
  }

  Future<String> folderTitle(AssetPathEntity folder) async {
    int total = await folder.assetCountAsync;
    return '${folder.name}:($total)';
  }

  void sortImageList(List<AssetEntity> imageList) {
    imageList.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));
  }
}
