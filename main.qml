import QtQuick 2.3
import QtQuick.Controls 1.2
import QtMultimedia 5.0

import "twitch.js" as Twitch

ApplicationWindow {
    visible: true
    width: 1060
    height: 700
    title: qsTr("Quiche")

    StackView {
        id: stack
        initialItem: featuredStreams

        Component {
            id: featuredStreams

            Rectangle {
                width: parent.width
                height: parent.height

                Component.onCompleted: paginate();

                function paginate() {
                    if (typeof paginate.pages == 'undefined') {
                        paginate.pages = 0
                    }

                    Twitch.get_featured_streams(++paginate.pages, function(resp) {
                        for (var i = 0; i < resp.featured.length; ++i) {
                            var item = {
                                preview: resp.featured[i].stream.preview,
                                username: resp.featured[i].stream.channel.name,
                                title: resp.featured[i].stream.channel.status,
                                displayName: resp.featured[i].stream.channel.display_name
                            };
                            streamsModel.append(item);
                        }
                    });
                }

                Component {
                    id: streamsDelegate

                    Item {
                        id: streamItem
                        height: 200
                        width: 320

                        Column {
                            height: parent.height
                            width: parent.width

                            // Preview image
                            Image {
                                source: preview
                                width: parent.width
                            }

                            // Stream title
                            Label {
                                width: parent.width
                                text: title
                                elide: "ElideRight"
                                maximumLineCount: 1
                                color: streamItem.activeFocus ? "red" : "black"
                            }
                        }

                        Keys.onReturnPressed: {
                            Twitch.get_stream_uris(username, function(uris) {
                                stack.push(streamPlayer, {uri: uris[1]});
                            });
                        }
                    }
                }

                GridView {
                    id: streams
                    model: streamsModel
                    delegate: streamsDelegate
                    anchors.fill: parent
                    anchors.margins: 20
                    cellHeight: 220
                    cellWidth: 340
                    focus: true
                    clip: true

                    onAtYEndChanged: {
                        if (streams.atYEnd && !streams.atYBeginning) {
                            parent.paginate();
                        }
                    }
                }

                ListModel {
                    id: streamsModel

                }
            }
        }

        Component {
            id: streamPlayer

            Rectangle {
                width: parent.width
                height: parent.height

                property string uri

                MediaPlayer {
                    id: player
                    source: uri
                    autoPlay: true
                }

                VideoOutput {
                    id: videoOutput
                    source: player
                    anchors.fill: parent
                }
            }

        }
    }
}
