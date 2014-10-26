import QtQuick 2.3
import QtQuick.Controls 1.2

import "twitch.js" as Twitch

ApplicationWindow {
    visible: true
    width: 1060
    height: 700
    title: qsTr("Quiche")

    StackView {
        id:stack
        initialItem: featuredStreams

        Component {
            id:featuredStreams

            Rectangle {
                width: parent.width
                height: parent.height

                Component.onCompleted: startup();

                function startup() {
                    Twitch.get_featured_streams(function(resp) {
                        for (var i = 0; i < resp.featured.length; ++i) {
                            var item = {
                                preview: resp.featured[i].stream.preview,
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
                                color: streamItem.activeFocus ? "red" : "black"
                            }
                        }

                        Keys.onReturnPressed: {
                            print("Streamed by " + displayName)
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
                }

                ListModel {
                    id: streamsModel

                }
            }
        }
    }
}
