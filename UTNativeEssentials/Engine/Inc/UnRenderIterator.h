// UnRenderIterator.h

#if ((_MSC_VER) || (HAVE_PRAGMA_PACK))
#pragma pack(push,OBJECT_ALIGNMENT)
#endif

class ENGINE_API URenderIterator : public UObject
{
    DECLARE_CLASS(URenderIterator,UObject,0,Engine)

	// Constructor
	URenderIterator();

    INT MaxItems;
    INT Index;
    APlayerPawn* Observer;
    FSceneNode* Frame;

	// URenderIterator interface
	virtual void Init( FSceneNode* Camera );	//override to initialize subclass data (call Super required)
	virtual void UnInit();						//must be called before Camera goes out of scope.
	virtual void First();
	virtual void Next();
	virtual bool IsDone();						//override to adjust iteration termination criteria (call Super recommended)
	virtual AActor* CurrentItem();				//override to adjust actor render properties based on Index (call Super recommended)
};

#if ((_MSC_VER) || (HAVE_PRAGMA_PACK))
#pragma pack (pop)
#endif
