using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace Noc7c9.DyeDontDie {

    [CustomEditor(typeof(GameManager))]
    public class GameManagerEditor : Editor {

        public override void OnInspectorGUI() {
            GameManager gm = target as GameManager;

            if (DrawDefaultInspector()) {
                gm.UpdateColors();
            }
        }

    }

}
