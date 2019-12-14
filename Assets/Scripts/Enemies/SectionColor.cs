using UnityEngine;

namespace Noc7c9.DyeDontDie
{

    public class SectionColor : MonoBehaviour
    {

        [SerializeField]
        private SpriteRenderer solid = null;

        [SerializeField]
        private long colorIndex = 0;
        [SerializeField]
        private bool isWhite = true;

        void Start()
        {
            solid.color = GetColor();
        }

        public bool IsWhite()
        {
            return isWhite;
        }

        public long GetColorIndex()
        {
            return colorIndex;
        }

        public Color GetColor()
        {
            if (isWhite)
            {
                return Color.white;
            }
            return ServiceLocator.WorldColorManager.GetColor(colorIndex);
        }
    }

}