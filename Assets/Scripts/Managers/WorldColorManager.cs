using UnityEngine;
using UnityEditor;

namespace Noc7c9.DyeDontDie {

    public class WorldColorManager : MonoBehaviour {

        public Camera cam;

        [SerializeField]
        private Color[] colors = null;

        private long activeColorIndex;

        public long GetActiveColorIndex() {
            return activeColorIndex;
        }

        public Color GetActiveColor() {
            return colors[activeColorIndex];
        }

        public Color[] GetColors() {
            return colors;
        }

        public Color GetColor(long colorIndex) {
            return colors[colorIndex % colors.Length];
        }

        public event System.Action<long> ColorChanged;
        void OnColorChanged() {
            var evt = ColorChanged;
            if (evt != null) {
                evt(activeColorIndex);
            }
        }

        public void CycleColor() {
            activeColorIndex = (activeColorIndex + 1) % colors.Length;
            OnColorChanged();
        }

        void OnValidate() {
            activeColorIndex = (long)Mathf.Clamp(activeColorIndex, 0, colors.Length);
        }

        void UpdateColors() {
            if (cam != null) {
                cam.backgroundColor = GetActiveColor();
            }
        }

        void Update() {
            UpdateColors();
        }

        [CustomEditor(typeof(WorldColorManager))]
        public class WorldColorManagerEditor : Editor {

            public override void OnInspectorGUI() {
                if (DrawDefaultInspector()) {
                    (target as WorldColorManager).UpdateColors();
                }
            }

        }

    }

}
