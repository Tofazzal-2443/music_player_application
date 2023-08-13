import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/consts/colors.dart';
import 'package:music_player_app/consts/text_styles.dart';
import 'package:music_player_app/controllers/player_controller.dart';
import 'package:music_player_app/pages/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          leading: const Icon(
            Icons.sort_rounded,
          ),
          title: Text(
            "Beats",
            style: ourStyle(
              family: 'bold',
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            sortType: null,
            uriType: UriType.EXTERNAL,
          ),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No song found",
                  style: ourStyle(),
                ),
              );
            } else {
              //print(snapshot.data);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.blueGrey,
                          child: Obx(
                            () => ListTile(
                              title: Text(
                                snapshot.data![index].displayNameWOExt,
                                style: ourStyle(
                                  family: bold,
                                  size: 15,
                                ),
                              ),
                              subtitle: Text(
                                "${snapshot.data![index].artist}",
                                style: ourStyle(
                                  family: regular,
                                  size: 12,
                                ),
                              ),
                              leading: QueryArtworkWidget(
                                id: snapshot.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note,
                                  color: whiteColor,
                                  size: 32,
                                ),
                              ),
                              trailing: controller.playIndex == index &&
                                      controller.isPlaying.value
                                  ? const Icon(
                                      Icons.play_arrow,
                                      color: whiteColor,
                                      size: 26,
                                    )
                                  : null,
                              onTap: () {
                                Get.to(
                                    () => PlayerPage(
                                          data: snapshot.data!,
                                        ),
                                    transition: Transition.downToUp);
                                controller.playSong(
                                    snapshot.data![index].uri, index);
                              },
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
          },
        ));
  }
}
