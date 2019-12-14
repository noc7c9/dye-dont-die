using UnityEngine;


namespace Noc7c9.DyeDontDie
{

    public class Tangibility : MonoBehaviour
    {

        [SerializeField]
        private SpriteRenderer solid = null;
        [SerializeField]
        private SpriteRenderer dotted = null;

        [SerializeField]
        private bool isTangible = true;

        void Start()
        {
            solid.enabled = isTangible;
            dotted.enabled = !isTangible;
        }
    }

}