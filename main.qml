import QtQuick 2.3
import QtQuick.Controls 1.2

import "twitch.js" as Twitch

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Quiche")

    Rectangle {
        width: parent.width
        height: parent.height
        Component.onCompleted: startup();

        function startup() {
            Twitch.get_featured_streams(function(resp) {
                for (var i = 0; i < resp.featured.length; ++i) {
                    streamsModel.append({
                        preview: resp.featured[i].stream.preview,
                        title: resp.featured[i].stream.channel.status
                    });
                }
            });
        }

        Component {
            id: streamsDelegate

            Item {
                width: 320
                height: 200

                Column {
                    width: parent.width
                    height: parent.height
                    Row {
                        width: parent.width
                        Image {
                            source: preview
                        }
                    }
                    Row {
                        width: parent.width
                        Label {
                            width: parent.width
                            text: title
                            elide: "ElideRight"
                        }
                    }
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
        }

        ListModel {
            id: streamsModel
        }
    }
}
