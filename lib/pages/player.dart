import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/consts/colors.dart';
import 'package:music_player_app/consts/text_styles.dart';
import 'package:music_player_app/controllers/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerPage extends StatelessWidget {
  final List<SongModel> data;

  const PlayerPage({Key? key, required this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => Expanded(
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: 330,
                  width: 330,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: QueryArtworkWidget(
                    id: data[controller.playIndex.value].id,
                    type: ArtworkType.AUDIO,
                    artworkHeight: double.infinity,
                    artworkWidth: double.infinity,
                    nullArtworkWidget: const Icon(
                      Icons.music_note,
                      size: 48,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Obx(
                  () => Column(
                    children: [
                      Text(
                        data[controller.playIndex.value].displayNameWOExt,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(
                          color: bgDarkColor,
                          family: bold,
                          size: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        data[controller.playIndex.value].artist.toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(
                          color: bgDarkColor,
                          family: regular,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Obx(
                          () => Row(
                            children: [
                              Text(
                                controller.duration.value,
                                style: ourStyle(color: bgDarkColor),
                              ),
                              Expanded(
                                child: Slider(
                                  thumbColor: sliderColor,
                                  inactiveColor: bgColor,
                                  activeColor: sliderColor,
                                  min: const Duration(
                                    seconds: 0,
                                  ).inSeconds.toDouble(),
                                  max: controller.max.value,
                                  value: controller.value.value,
                                  onChanged: (newValue) {},
                                ),
                              ),
                              Text(
                                controller.position.value,
                                style: ourStyle(color: bgDarkColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                controller.playSong(
                                    data[controller.playIndex.value - 1].uri,
                                    controller.playIndex.value - 1);
                              },
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                size: 35,
                                color: bgDarkColor,
                              )),
                          Obx(
                            () => CircleAvatar(
                              radius: 25,
                              backgroundColor: bgColor,
                              child: Transform.scale(
                                scale: 2,
                                child: IconButton(
                                  onPressed: () {
                                    if (controller.isPlaying.value) {
                                      controller.audioPlayer.pause();
                                      controller.isPlaying(false);
                                    } else {
                                      controller.audioPlayer.pause();
                                      controller.isPlaying(true);
                                    }
                                  },
                                  icon: controller.isPlaying.value
                                      ? const Icon(
                                          Icons.pause,
                                          color: whiteColor,
                                        )
                                      : const Icon(
                                          Icons.play_arrow_rounded,
                                          color: whiteColor,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.playSong(
                                  data[controller.playIndex.value +1].uri,
                                  controller.playIndex.value + 1);
                            },
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              size: 35,
                              color: bgDarkColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
