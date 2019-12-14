using UnityEngine;
using UnityEditor;

namespace Noc7c9.DyeDontDie
{

    [CustomEditor(typeof(WorldColorManager))]
    public class WorldColorManagerEditor : Editor
    {

        public override void OnInspectorGUI()
        {
            if (DrawDefaultInspector())
            {
                (target as WorldColorManager).UpdateColors();
            }
        }

    }

}