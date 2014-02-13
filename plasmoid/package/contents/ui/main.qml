import QtQuick 1.1

import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.qtextracomponents 0.1 as QtExtra
import org.kde.milou 0.1 as Milou

import "../code/globals.js" as Globals

Item {
    id: mainWidget
    property int minimumWidth: Globals.PlasmoidWidth
    property int maximumWidth: Globals.PlasmoidWidth
    property int minimumHeight: wrapper.minimumHeight + wrapper.anchors.topMargin + wrapper.anchors.bottomMargin
    property int maximumHeight: minimumHeight

    // The wrapper just exists for giving an appropriate top/bottom margin
    // when it is placed on the top/bottom edge of the screen
    Item {
        id: wrapper

        //
        // The +20 is so that the minimumHeight is always atleast 20+. If the height
        // is too small then Plasma will ignore the fact that it is a PopupApplet
        // and put the SearchField directly in the panel.
        //
        property int minimumHeight: listView.count ? listView.contentHeight + searchField.height + 5
                                                   : searchField.height + 20
        property int maximumHeight: minimumHeight

        anchors {
            fill: parent
            topMargin: plasmoid.isTopEdge() ? 7 : 0
            bottomMargin: plasmoid.isBottomEdge() ? 7 : 0
        }

        SearchField {
            id: searchField

            anchors {
                left: parent.left
                right: parent.right
            }
            onTextChanged: {
                listView.setQueryString(text)
            }
        }

        ResultsView {
            id: listView

            anchors {
                left: parent.left
                right: parent.right

                // vHanda: Random number - Is there some way to use consisten margins?
                //         PlasmaCore.FrameSvg does have margins, but one needs to construct
                //          a PlasmaCore.FrameSvg for that
                topMargin: plasmoid.isBottomEdge() ? 0 : 5
                bottomMargin: plasmoid.isBottomEdge() ? 5 : 0
            }
        }

        Component.onCompleted: {
            plasmoid.popupEventSignal.connect(setTextFieldFocus)
            //
            // The focus is not always set correctly. The hunch is that this
            // function is called before the popup is actually visible and
            // therfore the setFocus call does not do anything. So, we are using
            // a small timer and calling the setTextFieldFocus function again.
            //
            plasmoid.popupEventSignal.connect(theFocusDoesNotAlwaysWorkTimer.start)
            plasmoid.settingsChanged.connect(loadSettings)

            if (!plasmoid.isBottomEdge()) {
                // Normal view
                searchField.anchors.top = wrapper.top
                listView.anchors.top = searchField.bottom
                listView.anchors.bottom = wrapper.bottom
            }
            else {
                // When on the bottom
                listView.anchors.top = wrapper.top
                listView.anchors.bottom = searchField.top
                searchField.anchors.bottom = wrapper.bottom
            }
        }

        Timer {
            id: theFocusDoesNotAlwaysWorkTimer
            interval: 100
            repeat: false

            onTriggered: {
                wrapper.setTextFieldFocus(plasmoid.isShown())
            }
        }

        function setTextFieldFocus(shown) {
            searchField.setFocus();
            searchField.selectAll();

            if (!shown)
                listView.clearPreview();
        }

        function loadSettings() {
            listView.loadSettings()
        }
    }
}
